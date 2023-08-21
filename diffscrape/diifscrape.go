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
func Scrape(uri string, filePath string) (*Diff[string], error) {
	// parse current file
	rf, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to open current file: %w", err)
	}
	defer rf.Close()
	// ファイルのサイズを取得
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
	fs := string(data[:count])
	// ファイル内の文字列を改行で分割して[]stringに格納したもの
	rules := []string{}
	for _, r := range strings.Split(fs, "\n") {
		prefix := "    - "
		if strings.HasPrefix(r, prefix) {
			rules = append(rules, strings.TrimPrefix(r, prefix))
		}
	}

	// scrape web page
	var code string
	c := colly.NewCollector()
	c.OnRequest(func(r *colly.Request) {
		fmt.Println("Visiting: ", r.URL)
	})
	c.OnHTML("pre code.yaml", func(e *colly.HTMLElement) {
		code = e.Text
	})
	if err := c.Visit(uri); err != nil {
		return nil, fmt.Errorf("failed to visit web page: %w", err)
	}

	// ファイル内の文字列を改行で分割して[]stringに格納したもの
	nRules := []string{}
	for _, r := range strings.Split(fs, "\n") {
		prefix := "    - "
		if strings.HasPrefix(r, prefix) {
			nRules = append(nRules, strings.TrimPrefix(r, prefix))
		}
	}

	// overwrite file
	prefixLines := `# GENERATED CODE - DO NOT MODIFY BY HAND
# See https://dart-lang.github.io/linter/lints/options/options.html
`
	wf, err := os.Create(filePath)
	if err != nil {
		return nil, fmt.Errorf("failed to open writable file: %w", err)
	}
	defer func() {
		err := wf.Close()
		if err != nil {
			slog.Error("failed to close written file: %w", err)
		}
	}()
	_, err = wf.Write([]byte(prefixLines + code + "\n"))
	if err != nil {
		return nil, fmt.Errorf("failed to write new rules: %w", err)
	}

	pair := NewPair[string](rules, nRules)
	diff := NewDiff[string](pair)
	return &diff, nil
}
