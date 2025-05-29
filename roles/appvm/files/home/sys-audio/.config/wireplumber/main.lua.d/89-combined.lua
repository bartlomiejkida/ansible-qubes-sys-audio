-- Fix from https://forum.qubes-os.org/t/audio-qube/20685/217

alsa_monitor.enabled = true
alsa_monitor.properties = {
  -- These properties override node defaults when running in a virtual machine.
  -- The rules below still override those.
  ["vm.node.defaults"] = {
   ["api.alsa.headroom"] = 0,
  },
}
alsa_monitor.rules = {
  {
    matches = {
      {
	{ "device.name", "matches", "alsa_card.pci*" },
      },
    },
    apply_properties = {
      ["api.alsa.use-acp"] = true,
      ["api.alsa.use-ucm"] = true,
      ["api.acp.auto-profile"] = false,
      ["api.acp.auto-port"] = false,
    },
  },
  {
    matches = {
      {
	{ "device.name", "matches", "alsa_card.usb*" },
      },
    },
    apply_properties = {
      ["api.alsa.use-acp"] = true,
      ["api.alsa.use-ucm"] = true,
      ["api.acp.auto-profile"] = false,
      ["api.acp.auto-port"] = false,
    },
  },
  {
    matches = {
      {
	-- Matches all sources.
	{ "node.name", "matches", "alsa_input.*" },
      },
      {
	-- Matches all sinks.
	{ "node.name", "matches", "alsa_output.*" },
      },
    },
    apply_properties = {
      ["api.alsa.headroom"]      = 0,
      ["session.suspend-timeout-seconds"] = 0,  -- 0 disables suspend
    },
  },
}
