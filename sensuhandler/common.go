// Library for all non-constant handler related variables used by the Yieldbot
// Infrastructure teams in sensu
//
// LICENSE:
//   Copyright 2015 Yieldbot. <devops@yieldbot.com>
//   Released under the MIT License; see LICENSE
//   for details.

package sensuhandler

// NotificationColor is a set of colors used by all handlers to provide a rich
// notification.
var NotificationColor = map[string]string{
	"green":  "#33CC33",
	"orange": "#FFFF00",
	"red":    "#FF0000",
	"yellow": "#FF6600",
}

// SensuEvent holds Sensu generated check results.
type SensuEvent struct {
	ID          string `json:"id"`
	Action      string `json:"action"`
	Timestamp   int64  `json:"timestamp"`
	Occurrences int    `json:"occurrences"`
	Client      struct {
		Name          string   `json:"name"`
		Address       string   `json:"address"`
		Subscriptions []string `json:"subscriptions"`
		Timestamp     int64    `json:"timestamp"`
		Version       string   `json:"version"`
		Environment   string   `json:"environment"`
	}
	Check struct {
		Source      string   `json:"source"`
		Name        string   `json:"name"`
		Issued      int64    `json:"issued"`
		Subscribers []string `json:"subscribers"`
		Interval    int      `json:"interval"`
		Command     string   `json:"command"`
		Output      string   `json:"output"`
		Status      int      `json:"status"`
		Handler     string   `json:"handler"`
		History     []string `json:"history"`
		Tags        []string `json:"tags"`
		Playbook    string   `json:"playbook"`
		Thresholds  struct {
			Critical int `json:"critical"`
			Warning  int `json:"warning"`
		}
	}
}

// EnvDetails holds environment variables provided by Oahi dropped via Chef.
type EnvDetails struct {
	Sensu struct {
		Environment string `json:"environment"`
		FQDN        string `json:"fqdn"`
		Hostname    string `json:"hostname"`
		Consul      struct {
			Tags       string `json:"tags"`
			Datacenter string `json:"datacenter"`
		}
	}
}
