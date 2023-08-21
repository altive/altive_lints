package diffscrape

import (
	"reflect"
	"testing"
)

func TestMain(t *testing.M) {
	print("before test\n")
	t.Run()
	print("after test\n")
}

func TestScrape(t *testing.T) {
	type args struct {
		uri                string
		filePath           string
		htmlQuerySelector  string
		filteringPrefix    string
		shouldRemovePrefix bool
	}
	tests := []struct {
		name    string
		args    args
		want    *Diff[string]
		wantErr bool
	}{
		{
			name: "test",
			args: args{
				uri:                "https://dart.dev/tools/linter-rules/all",
				filePath:           "testdata/rules.yaml",
				htmlQuerySelector:  "pre code.yaml",
				filteringPrefix:    "    - ",
				shouldRemovePrefix: true,
			},
			want:    &Diff[string]{Added: []string{}, Removed: []string{}},
			wantErr: false,
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := Scrape(
				test.args.uri,
				test.args.filePath,
				test.args.htmlQuerySelector,
				test.args.filteringPrefix,
				test.args.shouldRemovePrefix,
			)
			if (err != nil) != test.wantErr {
				t.Errorf("error: %v, wantErr %v", err, test.wantErr)
				return
			}
			if !reflect.DeepEqual(got, test.want) {
				t.Errorf("got: %v, want %v", got, test.want)
			}
		})
	}
}
