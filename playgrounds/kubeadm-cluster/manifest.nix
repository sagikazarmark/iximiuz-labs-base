{
  images,
  lib,
  pkgs,
  ...
}:
let
  workerIndices = [
    "01"
    "02"
    "03"
    "04"
  ];
  workerNames = map (i: "kubeadm-${i}") workerIndices;

  mkWorker = index: {
    name = "kubeadm-${index}";
    users = [
      { name = "root"; }
      {
        name = "laborant";
        default = true;
      }
    ];
    drives = [
      {
        source = images.main.passthru.imageRef;
        mount = "/";
      }
    ];
    network.interfaces = [
      {
        network = "local";
        address = "172.16.0.${toString (10 + pkgs.lib.toInt (pkgs.lib.removePrefix "0" index))}";
      }
    ];
    startupFiles = [
      {
        path = "/etc/hosts";
        content = "\n172.16.0.254 control-plane control-plane.local\n";
        append = true;
      }
    ];
    resources = {
      cpuCount = 2;
      ramSize = "3GiB";
    };
  };

  mkWorkerTab = index: {
    id = "terminal-${index}";
    kind = "terminal";
    name = "kubeadm-${index}";
    machine = "kubeadm-${index}";
  };
in
{
  base = "flexbox";
  title = "kubeadm Cluster";
  description = "TODO";
  channels = {
    live = {
      name = "kubeadm-cluster-2766906f";
      public = true;
    };
    dev = {
      name = "kubeadm-cluster-2766906f.dev";
    };
  };
  cover = lib.hashedCover ./cover.svg;
  categories = [ "kubernetes" ];
  playground = {
    networks = [
      {
        name = "local";
        subnet = "172.16.0.0/24";
      }
    ];
    machines = [
      {
        name = "dev-machine";
        users = [
          { name = "root"; }
          {
            name = "laborant";
            default = true;
          }
        ];
        drives = [
          {
            source = images."dev-machine".passthru.imageRef;
            mount = "/";
          }
        ];
        network.interfaces = [
          {
            network = "local";
            address = "172.16.0.2";
          }
        ];
        startupFiles = [
          {
            path = "/etc/hosts";
            content = "\n172.16.0.254 control-plane control-plane.local\n";
            append = true;
          }
        ];
        resources = {
          cpuCount = 2;
          ramSize = "3GiB";
        };
      }
    ]
    ++ map mkWorker workerIndices;
    tabs = [
      {
        id = "terminal-dev";
        kind = "terminal";
        name = "dev-machine";
        machine = "dev-machine";
      }
    ]
    ++ map mkWorkerTab workerIndices;
    # Tasks expanded per-worker (labx render expects single-machine).
    initTasks = builtins.listToAttrs (
      builtins.concatMap (
        w:
        let
          s = "_${builtins.replaceStrings [ "-" ] [ "_" ] w}";
        in
        [
          {
            name = "init_oci${s}";
            value = {
              name = "init_oci${s}";
              init = true;
              machine = w;
              user = "root";
              run = "/usr/share/containerd/configure-oci.sh\n/usr/share/crio/configure-oci.sh";
            };
          }
          {
            name = "init_start_containerd${s}";
            value = {
              name = "init_start_containerd${s}";
              init = true;
              machine = w;
              user = "root";
              needs = [ "init_oci${s}" ];
              run = "/usr/share/containerd/start.sh";
              conditions = [
                {
                  key = "Container runtime";
                  value = "containerd";
                }
              ];
            };
          }
          {
            name = "init_start_crio${s}";
            value = {
              name = "init_start_crio${s}";
              init = true;
              machine = w;
              user = "root";
              needs = [ "init_oci${s}" ];
              run = "/usr/share/crio/start.sh";
              conditions = [
                {
                  key = "Container runtime";
                  value = "cri-o";
                }
              ];
            };
          }
        ]
      ) workerNames
    );
    initConditions = {
      values = [
        {
          key = "Container runtime";
          default = "containerd";
          options = [
            "containerd"
            "cri-o"
          ];
        }
        {
          key = "OCI runtime";
          default = "runc";
          options = [
            "runc"
            "crun"
          ];
        }
        {
          key = "Network addon";
          default = "flannel";
          options = [
            "none"
            "flannel"
            "canal"
          ];
        }
      ];
    };
  };
}
