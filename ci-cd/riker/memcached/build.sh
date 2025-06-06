#!/bin/sh

CFLAGS="-DHAVE_CONFIG_H -I. -g -O2 -pthread -pthread -Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls"

MEMCACHED_SRC="memcached.c hash.c jenkins_hash.c murmur3_hash.c slabs.c items.c assoc.c thread.c daemon.c stats_prefix.c util.c cache.c bipbuffer.c logger.c crawler.c itoa_ljust.c slab_automove.c authfile.c restart.c extstore.c crc32c.c storage.c slab_automove_extstore.c"

TESTAPP_SRC="testapp.c util.c stats_prefix.c jenkins_hash.c murmur3_hash.c cache.c crc32c.c"

# Conditionals to handle changes in memcached build over the 100 commits
if [ -f "proto_text.c" ];
then
  MEMCACHED_SRC="$MEMCACHED_SRC proto_text.c proto_bin.c"
else
  TESTAPP_SRC="$TESTAPP_SRC hash.c"
fi

# # Build the release version of memcached
# gcc $CFLAGS -DNDEBUG -o memcached $MEMCACHED_SRC -levent
# # Build the debug version of memcached
# gcc $CFLAGS -fprofile-arcs -ftest-coverage -DMEMCACHED_DEBUG -o memcached-debug $MEMCACHED_SRC -levent
# # Build the sizes executable
# gcc $CFLAGS -o sizes sizes.c -levent
# # Build the testapp executable
# gcc $CFLAGS -o testapp $TESTAPP_SRC -levent
# # Build the timedrun executable
# gcc $CFLAGS -o timedrun timedrun.c -levent
gcc $CFLAGS -DNDEBUG -o memcached $MEMCACHED_SRC -levent &
gcc $CFLAGS -fprofile-arcs -ftest-coverage -DMEMCACHED_DEBUG -o memcached-debug $MEMCACHED_SRC -levent &
gcc $CFLAGS -o sizes sizes.c -levent &
gcc $CFLAGS -o testapp $TESTAPP_SRC -levent &
gcc $CFLAGS -o timedrun timedrun.c -levent &
wait