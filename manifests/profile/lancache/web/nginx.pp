#
# This is lifted from https://github.com/steamcache/monolithic
#
class profile::lancache::web::nginx {
    class { '::nginx':
        log_format                   => {
            'cachelog' =>
            '[$cacheidentifier] $remote_addr / $http_x_forwarded_for - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_cache_status" "$host" "$http_range"'
        },
        proxy_cache_path             => '/mnt/LanCache/cache/',
        proxy_cache_levels           => '2:2',
        proxy_cache_keys_zone        => 'generic:500m',
        proxy_cache_max_size         => '1000000m',
        proxy_cache_inactive         => '200d',
        proxy_use_temp_path          => 'off',
        proxy_cache_loader_files     => 1000,
        proxy_cache_loader_sleep     => '50ms',
        proxy_cache_loader_threshold => '300ms',
        daemon_group                 => 'lancache-rw',
        http_tcp_nopush              => 'on',
        types_hash_max_size          => '2048',
        gzip                         => 'on',
        proxy_ignore_header          => ['Expires', 'Cache-Control'] # this exists for ::location but not ::server
    }

    # Origin has been seen downloading https client downloads on origin-a.akamaihd.net.
    # A solution should be in place to forward https to the origin server (egsniproxy)'
    #
    # Do NOT cache manifest.patch.daybreakgames.com
    nginx::resource::map { 'cacheidentifier':
        ensure    => present,
        hostnames => true,
        default   => '$http_host',
        string    => '$http_host',
        mappings  => {
            'assetcdn.101.arenanetworks.com'                => 'arenanet',
            'assetcdn.102.arenanetworks.com'                => 'arenanet',
            'assetcdn.103.arenanetworks.com'                => 'arenanet',
            'dist.blizzard.com'                             => 'blizzard',
            'dist.blizzard.com.edgesuite.net'               => 'blizzard',
            'llnw.blizzard.com'                             => 'blizzard',
            'edgecast.blizzard.com'                         => 'blizzard',
            'blizzard.vo.llnwd.net'                         => 'blizzard',
            'blzddist1-a.akamaihd.net'                      => 'blizzard',
            'blzddist2-a.akamaihd.net'                      => 'blizzard',
            'blzddist3-a.akamaihd.net'                      => 'blizzard',
            'blzddist4-a.akamaihd.net'                      => 'blizzard',
            'level3.blizzard.com'                           => 'blizzard',
            'nydus.battle.net'                              => 'blizzard',
            'edge.blizzard.top.comcast.net'                 => 'blizzard',
            'cdn.blizzard.com'                              => 'blizzard',
            '*.cdn.blizzard.com'                            => 'blizzard',
            'pls.patch.daybreakgames.com'                   => 'daybreak',
            'ccs.cdn.wup.shop.nintendo.com'                 => 'nintendo',
            'pushmo.hac.lp1.eshop.nintendo.net'             => 'nintendo',
            'ecs-lp1.hac.shop.nintendo.net'                 => 'nintendo',
            'receive-lp1.dg.srv.nintendo.net'               => 'nintendo',
            'aqua.hac.lp1.d4c.nintendo.net'                 => 'nintendo',
            'atum.hac.lp1.d4c.nintendo.net'                 => 'nintendo',
            'bugyo.hac.lp1.eshop.nintendo.net'              => 'nintendo',
            'tagaya.hac.lp1.eshop.nintendo.net'             => 'nintendo',
            'origin-a.akamaihd.net'                         => 'origin',
            'akamai.cdn.ea.com'                             => 'origin',
            'lvlt.cdn.ea.com'                               => 'origin',
            'river.data.ea.com'                             => 'origin',
            'origin-a.akamaihd.net.edgesuite.net'           => 'origin',
            'rxp-fl.cncirc.net'                             => 'renegadex',
            'rxp-chi.cncirc.net'                            => 'renegadex',
            'rxp-nz.cncirc.net'                             => 'renegadex',
            'rxp-bgr.cncirc.net'                            => 'renegadex',
            'rxp-fr.cncirc.net'                             => 'renegadex',
            'rxp-nyc.cncirc.net'                            => 'renegadex',
            'rxp-uk.cncirc.net'                             => 'renegadex',
            'rxp-sg.cncirc.net'                             => 'renegadex',
            'rxp-la.cncirc.net'                             => 'renegadex',
            'rxp-fin.cncirc.net'                            => 'renegadex',
            'denver1.renegade-x.com'                        => 'renegadex',
            'l3cdn.riotgames.com'                           => 'riot',
            'worldwide.l3cdn.riotgames.com'                 => 'riot',
            'riotgamespatcher-a.akamaihd.net'               => 'riot',
            'riotgamespatcher-a.akamaihd.net.edgesuite.net' => 'riot',
            'lol.dyn.riotcdn.net'                           => 'riot',
            'pls.patch.station.sony.com'                    => 'sony',
            'gs2.ww.prod.dl.playstation.net'                => 'sony',
            '*.content.steampowered.com'                    => 'steam',
            'content1.steampowered.com'                     => 'steam',
            'content2.steampowered.com'                     => 'steam',
            'content3.steampowered.com'                     => 'steam',
            'content4.steampowered.com'                     => 'steam',
            'content5.steampowered.com'                     => 'steam',
            'content6.steampowered.com'                     => 'steam',
            'content7.steampowered.com'                     => 'steam',
            'content8.steampowered.com'                     => 'steam',
            'cs.steampowered.com'                           => 'steam',
            'steamcontent.com'                              => 'steam',
            'client-download.steampowered.com'              => 'steam',
            '*.hsar.steampowered.com.edgesuite.net'         => 'steam',
            '*.akamai.steamstatic.com'                      => 'steam',
            'content-origin.steampowered.com'               => 'steam',
            'clientconfig.akamai.steamtransparent.com'      => 'steam',
            'steampipe.akamaized.net'                       => 'steam',
            'edgecast.steamstatic.com'                      => 'steam',
            'steam.apac.qtlglb.com.mwcloudcdn.com'          => 'steam',
            '*.cs.steampowered.com'                         => 'steam',
            '*.cm.steampowered.com'                         => 'steam',
            '*.edgecast.steamstatic.com'                    => 'steam',
            '*.steamcontent.com'                            => 'steam',
            'cdn1-sea1.valve.net'                           => 'steam',
            'cdn2-sea1.valve.net'                           => 'steam',
            '*.steam-content-dnld-1.apac-1-cdn.cqloud.com'  => 'steam',
            '*.steam-content-dnld-1.eu-c1-cdn.cqloud.com'   => 'steam',
            'steam.apac.qtlglb.com'                         => 'steam',
            'edge.steam-dns.top.comcast.net'                => 'steam',
            'edge.steam-dns-2.top.comcast.net'              => 'steam',
            'steam.naeu.qtlglb.com'                         => 'steam',
            'steampipe-kr.akamaized.net'                    => 'steam',
            'steam.ix.asn.au'                               => 'steam',
            'steam.eca.qtlglb.com'                          => 'steam',
            'steam.cdn.on.net'                              => 'steam',
            'update5.dota2.wmsj.cn'                         => 'steam',
            'update2.dota2.wmsj.cn'                         => 'steam',
            'update6.dota2.wmsj.cn'                         => 'steam',
            'update3.dota2.wmsj.cn'                         => 'steam',
            'update1.dota2.wmsj.cn'                         => 'steam',
            'update4.dota2.wmsj.cn'                         => 'steam',
            'update5.csgo.wmsj.cn'                          => 'steam',
            'update2.csgo.wmsj.cn'                          => 'steam',
            'update4.csgo.wmsj.cn'                          => 'steam',
            'update3.csgo.wmsj.cn'                          => 'steam',
            'update6.csgo.wmsj.cn'                          => 'steam',
            'update1.csgo.wmsj.cn'                          => 'steam',
            'st.dl.bscstorage.net'                          => 'steam',
            'cdn.mileweb.cs.steampowered.com.8686c.com'     => 'steam',
            '*.cdn.ubi.com'                                 => 'uplay',
            'd3rmjivj4k4f0t.cloudfront.net'                 => 'twitch',
            'addons.forgesvc.net'                           => 'twitch',
            'media.forgecdn.net'                            => 'twitch',
            'files.forgecdn.net'                            => 'twitch',
            'dl1.wargaming.net'                             => 'wargaming',
            'dl2.wargaming.net'                             => 'wargaming',
            'wg.gcdn.co'                                    => 'wargaming',
            'wgusst-na.wargaming.net'                       => 'wargaming',
            'wgusst-eu.wargaming.net'                       => 'wargaming',
            'update-v4r4h10x.worldofwarships.com'           => 'wargaming',
            'wgus-wotasia.wargaming.net'                    => 'wargaming',
            'dl-wot-ak.wargaming.net'                       => 'wargaming',
            'dl-wot-gc.wargaming.net'                       => 'wargaming',
            'dl-wot-se.wargaming.net'                       => 'wargaming',
            'dl-wot-cdx.wargaming.net'                      => 'wargaming',
            'dl-wows-ak.wargaming.net'                      => 'wargaming',
            'dl-wows-gc.wargaming.net'                      => 'wargaming',
            'dl-wows-se.wargaming.net'                      => 'wargaming',
            'dl-wows-cdx.wargaming.net'                     => 'wargaming',
            'dl-wowp-ak.wargaming.net'                      => 'wargaming',
            'dl-wowp-gc.wargaming.net'                      => 'wargaming',
            'dl-wowp-se.wargaming.net'                      => 'wargaming',
            'dl-wowp-cdx.wargaming.net'                     => 'wargaming',
            'officecdn.microsoft.com'                       => 'wsus',
            '*.windowsupdate.com'                           => 'wsus',
            'windowsupdate.com'                             => 'wsus',
            '*.dl.delivery.mp.microsoft.com'                => 'wsus',
            'dl.delivery.mp.microsoft.com'                  => 'wsus',
            '*.update.microsoft.com'                        => 'wsus',
            '*.do.dsp.mp.microsoft.com'                     => 'wsus',
            '*.microsoft.com.edgesuite.net'                 => 'wsus',
            'assets1.xboxlive.com'                          => 'xboxlive',
            'assets2.xboxlive.com'                          => 'xboxlive',
            'dlassets.xboxlive.com'                         => 'xboxlive',
            'xboxone.loris.llnwd.net'                       => 'xboxlive',
            '*.xboxone.loris.llnwd.net'                     => 'xboxlive',
            'xboxone.vo.llnwd.net'                          => 'xboxlive',
            'xbox-mbr.xboxlive.com'                         => 'xboxlive',
            'assets1.xboxlive.com.nsatc.net'                => 'xboxlive',
        }
    }

    # Fix for League of Legends Updater
    nginx::resource::location { 'leagueoflegends':
        server   => 'generic',
        location => '~ ^.+(releaselisting_.*|.version$)',
        proxy    => 'http://$host',
    }
    nginx::resource::location { 'steamcache-heartbeat':
        server              => 'generic',
        location            => '/steamcache-heartbeat',
        add_header          => {
            'X-SteamCache-Processed-By' => '$hostname'
        },
        location_cfg_append => { 'return' => '204' }
    }

    nginx::resource::server { 'generic':
        listen_port              => 80,
        listen_options           => 'reuseport',
        format_log               => 'cachelog',
        resolver                 => [
            '8.8.8.8',
            '8.8.4.4',
            'ipv6=off'
        ],
        add_header               => {
            'X-SteamCache-Processed-By' => '$hostname,$http_X_SteamCache_Processed_By',
            # Debug headers
            'X-Upstream-Status'         => '$upstream_status',
            'X-Upstream-Response-Time'  => '$upstream_response_time',
            'X-Upstream-Cache-Status'   => '$upstream_cache_status'
        },
        # Cache Location (see slice below)
        proxy_cache              => 'generic',
        server_cfg_append        => {
            'slice'                     => '1m',
            'proxy_cache_lock_timeout'  => '1h',
            'proxy_cache_revalidate'    => 'on', # Enable cache revalidation
            'proxy_next_upstream'       => 'error timeout http_404', # This isnt implemented for a / ::server
            'proxy_ignore_client_abort' => 'on',

        },
        proxy_set_header         => [
            'X-SteamCache-Processed-By $hostname',
            'Range $slice_range',
            # Upstream request headers
            'Host $host',
            'X-Real-IP $remote_addr',
            'X-Forwarded-For $proxy_add_x_forwarded_for'
        ],
        # Only download one copy at a time and use a large timeout so
        # this really happens, otherwise we end up wasting bandwith
        # getting the file multiple times.
        # See proxy_cache_lock_timeout above
        proxy_cache_lock         => 'on',
        # Allow the use of state entries
        proxy_cache_use_stale    => 'error timeout invalid_header updating http_500 http_502 http_503 http_504',
        # Allow caching of 200 but not 301 or 302 as our cache key may not include query
        # params hence may not be valid for all users
        proxy_cache_valid        => [
            '301 302 0',
            '200 206 3560d',
        ],
        # Don't cache requests marked as nocache=1
        proxy_cache_bypass       => '$arg_nocache',
        # 40G max file
        proxy_max_temp_file_size => '40960m',
        proxy_cache_key          => '$cacheidentifier$uri$slice_range',
        # Battle.net Fix
        proxy_hide_header        => [ 'ETag' ],
        # Upstream Configuration (see also proxy_ext_upstream and proxy_ignore_client_abort)
        proxy                    => 'http://$host$request_uri',
        proxy_redirect           => 'off',
        # # Abort any circular requests
        raw_append               => [
            'if ($http_X_SteamCache_Processed_By = $hostname) { return 508; }'
        ]
    }
}
