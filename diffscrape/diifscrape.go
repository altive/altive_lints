package diffscrape

import (
	"fmt"
	"log/slog"
	"os"
	"strings"

	"github.com/gocolly/colly/v2"
)

// uri e.g. "https://dart.dev/tools/linter-rules/all"
// filePath e.g. "../packages/altive_lints/lib/all_lint_rules.yaml"
func Scrape(
	uri string,
	filePath string,
	htmlQuerySelector string,
	filteringPrefix string,
	shouldRemovePrefix bool,
) (*Diff[string], error) {
	fileText, err := readFileText(filePath)
	if err != nil {
		return nil, err
	}

	webText, err := scrapeWebPage(uri, htmlQuerySelector)
	if err != nil {
		return nil, err
	}

	overwriteFile(filePath, *webText)

	previous := extract(*fileText, filteringPrefix, shouldRemovePrefix)
	latest := extract(*webText, filteringPrefix, shouldRemovePrefix)

	pair := NewPair[string](previous, latest)
	diff := NewDiff[string](pair)

	return &diff, nil
}

func readFileText(filePath string) (*string, error) {
	rf, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to open current file: %w", err)
	}
	defer rf.Close()

	info, err := rf.Stat()
	if err != nil {
		return nil, fmt.Errorf("failed to get file info: %w", err)
	}
	size := info.Size()
	data := make([]byte, size)
	count, err := rf.Read(data)
	if err != nil {
		return nil, fmt.Errorf("failed to read current file: %w", err)
	}
	fileText := string(data[:count])
	return &fileText, nil
}

func scrapeWebPage(uri string, htmlQuerySelector string) (*string, error) {
	var webText *string
	c := colly.NewCollector()
	c.OnRequest(func(r *colly.Request) {
		fmt.Println("Visiting: ", r.URL)
	})
	c.OnHTML(htmlQuerySelector, func(e *colly.HTMLElement) {
		webText = &e.Text
	})
	if err := c.Visit(uri); err != nil {
		return nil, fmt.Errorf("failed to visit web page: %w", err)
	}
	return webText, nil
}

func overwriteFile(filePath string, text string) error {
	wf, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("failed to open writable file: %w", err)
	}
	defer func() {
		err := wf.Close()
		if err != nil {
			slog.Error("failed to close written file: %w", err)
		}
	}()
	_, err = wf.Write([]byte(text + "\n"))
	if err != nil {
		return fmt.Errorf("failed to write new rules: %w", err)
	}
	return nil
}

func extract(fs string, filteringPrefix string, shouldRemovePrefix bool) []string {
	rules := []string{}
	for _, r := range strings.Split(fs, "\n") {
		if strings.HasPrefix(r, filteringPrefix) {
			if shouldRemovePrefix {
				r = strings.TrimPrefix(r, filteringPrefix)
			}
			rules = append(rules, r, filteringPrefix)
		}
	}
	return rules
}
