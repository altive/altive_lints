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
		uri      string
		expr     string
		filePath string
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
				uri:      "https://dart.dev/tools/linter-rules/all",
				filePath: "testdata/rules.yaml",
			},
			want:    &Diff[string]{Added: []string{}, Removed: []string{}},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Scrape(tt.args.uri, tt.args.filePath)
			if (err != nil) != tt.wantErr {
				t.Errorf("error: %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("got: %v, want %v", got, tt.want)
			}
		})
	}
}
