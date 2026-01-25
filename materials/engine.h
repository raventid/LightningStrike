#ifndef ENGINE_H
#define ENGINE_H

#include <stdint.h>

#define MAX_PRICE 10000
#define MIN_PRICE 1

typedef uint32_t t_price;
typedef uint32_t t_size;
typedef uint32_t t_orderid;
typedef uint32_t t_side;

typedef struct {
    char symbol[5];
    char trader[5];
    t_side side;
    t_price price;
    t_size size;
} t_order;

typedef struct {
    char symbol[5];
    char trader[5];
    t_side side;
    t_price price;
    t_size size;
} t_execution;

void execution(t_execution exec);
t_orderid limit(t_order order);
void cancel(t_orderid orderid);
void init();
void destroy();

#endif