#!/bin/sed -f
/^<\/Context/i\<Manager\ className\=\"com.orangefunction.tomcat.redissessions.RedisSessionManager\"\n\thost\=\"192.168.1.1:6379\"\n\tmaxInactiveInterval\=\"60\"\n\tsentinelMaster\=\"mymaster\"\n\tsentinels\=\"192.168.1.1:26379,10.173.32.12:26379,10.172.32.13:26379\" \/\>
