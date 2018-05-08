// Library for all global variables used by the Yieldbot
// Infrastructure teams in sensu
//
// LICENSE:
//   Copyright 2015 Yieldbot. <devops@yieldbot.com>
//   Released under the MIT License; see LICENSE
//   for details.

package sensuutil

// EnvironmentFile contains environmental details generated during the Chef run by Oahi.
const EnvironmentFile string = "/etc/sensu/conf.d/monitoring_infra.json"

// MonitoringErrorCodes provides a standard set of error codes to use.
// Please use the below codes instead of random non-zero so that monitoring can
// utilize existing maps for alerting and help avoid unnecessary noise.
var MonitoringErrorCodes = map[string]int{
	"GENERALGOLANGERROR": 129, // internal script error
	"CONFIGERROR":        127, // unix config error, not enough paramaters, etc
	"PERMISSIONERROR":    126, // not executable, etc
	"RUNTIMEERROR":       42,  // self explanatory
	"DEBUG":              37,  // You had the Alliance on you, criminals and savages… half the people on this
	// ship have been shot or wounded, including yourself, and you’re harboring known fugitives.
	"UNKNOWN":  3, // Would it save you a lot of time if I just gave up and went mad now?
	"CRITICAL": 2, // “The ships hung in the sky in much the same way that bricks don't.”
	"WARNING":  1, // this kinda sucks but don't get out of bed to deal with it
	"OK":       0, // “We’re still flying”

}
