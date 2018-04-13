#
#
#
node default {

}

node /^cfcczotac03/ {
    # include roles::camper::web::camper
    include roles::camper::java::windows
}