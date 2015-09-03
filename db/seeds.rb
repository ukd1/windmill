@cg = ConfigurationGroup.create(name: "default")
@cg.configurations.create(name:"default", version:1, notes:"test", config_json: File.open("osquery_configs/default.conf").read())
