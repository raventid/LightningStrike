/*
 * oracle_shim.c
 *
 * Compiles materials/engine.c with externally-visible symbols renamed to
 * oracle_* so the reference engine can be linked alongside our ATS engine
 * without collisions. The reference source is included verbatim — do NOT
 * modify materials/engine.c.
 *
 * Renamed exports:
 *   init               -> oracle_init
 *   destroy            -> oracle_destroy
 *   limit              -> oracle_limit
 *   cancel             -> oracle_cancel
 *   execution          -> oracle_execution    (the user-supplied callback)
 *   EXECUTE_TRADE      -> oracle_EXECUTE_TRADE (helper, defensive rename)
 *   ppInsertOrder      -> oracle_ppInsertOrder (helper, defensive rename)
 *
 * Test harness must provide:
 *   void oracle_execution(t_execution exec);
 */

#define init               oracle_init
#define destroy            oracle_destroy
#define limit              oracle_limit
#define cancel             oracle_cancel
#define execution          oracle_execution
#define EXECUTE_TRADE      oracle_EXECUTE_TRADE
#define ppInsertOrder      oracle_ppInsertOrder

#include "../materials/engine.c"
