# nginx-mogilefs


vim default.conf

    server {
        listen 80;
        server_name yourdomain.name;
        proxy_set_header Host $host;
        # This location could be used to retrieve files from MogileFS.
        # It is publicly available.
        #
        location /download/ {
            #
            # Query tracker at 192.168.2.2 for a file with the key
            # equal to remaining part of request URI
            #
            mogilefs_tracker 192.168.0.224:7001;
            mogilefs_domain test;

        mogilefs_pass {
            proxy_pass $mogilefs_path;
            proxy_hide_header Content-Type;
            proxy_buffering off;
            }
        }

        #
        # This location could be used to store or delete files in MogileFS.
        # It may be configured to be accessable only from local network.
        #
        location /upload/ {
            allow 192.168.2.0/24;
            deny all;

            mogilefs_tracker 192.168.0.224:7001;
            mogilefs_domain test;
            mogilefs_methods PUT DELETE;

            mogilefs_pass {
                proxy_pass $mogilefs_path;
                proxy_hide_header Content-Type;
                proxy_buffering off;
            }
         }
    }
