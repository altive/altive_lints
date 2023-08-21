package diffscrape

import "slices"

// Pair は、比較対象を保持する構造体です。
type Pair[T comparable] struct {
	Before, After []T
}

// NewPair returns a new Pair.
func NewPair[T comparable](before, after []T) Pair[T] {
	return Pair[T]{before, after}
}

// Diff は、比較結果を保持する構造体です。
type Diff[T comparable] struct {
	Added, Removed []T
}

// NewDiff returns a new Diff from Pair.
func NewDiff[T comparable](p Pair[T]) Diff[T] {
	added := []T{}
	for _, v := range p.After {
		found := slices.Contains(p.Before, v)
		if !found {
			added = append(added, v)
		}
	}
	removed := []T{}
	for _, v := range p.Before {
		found := slices.Contains(p.After, v)
		if !found {
			removed = append(removed, v)
		}
	}
	return Diff[T]{added, removed}
}
