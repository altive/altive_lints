package main

import (
	"log"

	"github.com/altive_lints/diffscrape"
)

func main() {
	diff, err := diffscrape.Scrape(
		"https://dart.dev/tools/linter-rules/all",
		"../../../packages/altive_lints/lib/all_lint_rules.yaml",
		"pre code.yaml",
		"    - ",
		true,
	)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Diff: %+v", diff)
}
