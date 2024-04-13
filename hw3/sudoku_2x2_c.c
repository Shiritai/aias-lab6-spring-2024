#include <stdio.h>
#include <stdlib.h>

const int box_width = 2;
const int side_lim = 4;
const int bound = 16;

#define true 1
#define false 0

static inline int check_and_mark(char shift, int *tb) {
  int hot = 1 << shift;
  if (shift && ((*tb) & hot))
    return false;
  *tb = (*tb) | hot;
  return true;
}

static inline int check(char *ls, int idx) {
  int x = idx % side_lim;
  int y = idx / side_lim;

  // horizontal scan by fixing y (in single dimension version)
  int base = y * side_lim;
  int tb = 0;
  for (int i = base; i < base + side_lim; ++i) {
    if (!check_and_mark(ls[i], &tb)) {
      return false;
    }
  }

  // vertical scan by fixing x
  base = x;
  tb = 0;
  for (int i = base; i < bound; i += side_lim) {
    if (!check_and_mark(ls[i], &tb)) {
      return false;
    }
  }

  // box scan by indirect index mapping
  tb = 0;
  int baseX = (x / box_width) * box_width;
  int baseY = (y / box_width) * box_width;
  for (int i = 0; i < box_width; ++i) {
    int offset = (i + baseY) * side_lim + baseX;
    for (int j = 0; j < box_width; ++j) {
      if (!check_and_mark(ls[offset + j], &tb)) {
        return false;
      }
    }
  }

  return true;
}

static inline int solve(char *ls, int idx) {
  if (idx == bound) {
    return true;
  }

  if (ls[idx] > 0) {
    return solve(ls, idx + 1);
  } else {
    for (char n = 1; n <= 4; ++n) {
      ls[idx] = n; // mark
      if (check(ls, idx) && solve(ls, idx + 1)) {
        return true;
      }
    }
    ls[idx] = 0;
    return false;
  }
}

int sudoku_2x2_c(char *ls) { return solve(ls, 0); }

// int main() {
//   char test_c_data[16] = {0, 2, 0, 3, 1, 3, 4, 0, 2, 0, 0, 4, 3, 0, 2, 0};

//   int is_success = sudoku_2x2_c(test_c_data);
//   printf("Success: %d\n", is_success);
//   for (int i = 0; i < side_lim; ++i) {
//       for (int j = 0; j < side_lim; ++j) {
//           printf("%c ", test_c_data[i * side_lim + j] + '0');
//       }
//       printf("\n");
//   }
// }