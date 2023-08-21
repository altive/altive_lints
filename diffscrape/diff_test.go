package diffscrape

import (
	"reflect"
	"testing"
)

type testCase[T comparable] struct {
	name string
	args Pair[T]
	want Diff[T]
}

func TestNewDiff(t *testing.T) {
	tests := []testCase[string]{
		{
			name: "追加が1つ、削除も1つの場合",
			args: Pair[string]{
				Before: []string{"a", "b", "c"},
				After:  []string{"a", "b", "d"},
			},
			want: Diff[string]{
				Added:   []string{"d"},
				Removed: []string{"c"},
			},
		},
		{
			name: "大文字と小文字は区別する",
			args: Pair[string]{
				Before: []string{"a", "b", "c"},
				After:  []string{"A", "B", "C"},
			},
			want: Diff[string]{
				Added:   []string{"A", "B", "C"},
				Removed: []string{"a", "b", "c"},
			},
		},
		{
			name: "URL",
			args: Pair[string]{
				Before: []string{"http://example.com"},
				After:  []string{"https://example.com"},
			},
			want: Diff[string]{
				Added:   []string{"https://example.com"},
				Removed: []string{"http://example.com"},
			},
		},
	}
	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			if got := NewDiff(tt.args); !reflect.DeepEqual(got, tt.want) {
				t.Fatalf("Diff is %v, want %v", got, tt.want)
			}
		})
	}
}
