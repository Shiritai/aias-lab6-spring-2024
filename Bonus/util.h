#ifndef UTIL_H
#define UTIL_H

#ifdef DEBUG_MODE
/**
 * @brief Print debug message if DEBUG_MODE is defined
 * otherwise, this will be optimized off
 */
#define print_debug_msg(...) \
  {                          \
    printf(__VA_ARGS__);     \
    fflush(stdout);          \
  }
#else
#define print_debug_msg(...) \
  {}
#endif

#endif /* UTIL_H */