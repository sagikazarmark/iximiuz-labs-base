{
  images,
  lib,
  ...
}:
{
  base = "flexbox";
  title = "kubeadm";
  description = ''
    A single-machine playground to experiment with kubeadm,
    a tool built to provide best-practice "fast paths" for creating Kubernetes clusters.
  '';
  channels = {
    live = {
      name = "kubeadm-072aadb3";
      public = true;
    };
    dev = {
      name = "kubeadm-072aadb3.dev";
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
    machines =
      let
        users = [
          { name = "root"; }
          {
            name = "laborant";
            default = true;
          }
        ];
        resources = {
          cpuCount = 4;
          ramSize = "8GiB";
        };
      in
      [
        {
          inherit users resources;

          name = "dev-machine";
          drives = [
            {
              source = images."dev-machine".passthru.imageRef;
              mount = "/";
            }
          ];
          network.interfaces = [
            { network = "local"; }
          ];
          startupFiles = [
            {
              path = "/etc/environment";
              append = true;
              content = "KUBE_CPLANE_HOST=kubeadm\n";
            }
          ];
        }
        {
          inherit users resources;

          name = "kubeadm";
          drives = [
            {
              source = images.main.passthru.imageRef;
              mount = "/";
            }
          ];
          network.interfaces = [
            {
              network = "local";
              address = "172.16.0.2";
            }
          ];
        }
      ];
    tabs = [
      {
        id = "terminal-dev";
        kind = "terminal";
        name = "dev-machine";
        machine = "dev-machine";
      }
      {
        id = "terminal";
        kind = "terminal";
        name = "kubeadm";
        machine = "kubeadm";
      }
    ];
    initTasks = {
      init_oci = {
        init = true;
        machine = "kubeadm";
        user = "root";
        run = ''
          /usr/share/containerd/configure-oci.sh
          /usr/share/crio/configure-oci.sh
        '';
      };
      init_start_containerd = {
        init = true;
        machine = "kubeadm";
        user = "root";
        needs = [ "init_oci" ];
        run = "/usr/share/containerd/start.sh";
        conditions = [
          {
            key = "Container runtime";
            value = "containerd";
          }
        ];
      };
      init_start_crio = {
        init = true;
        machine = "kubeadm";
        user = "root";
        needs = [ "init_oci" ];
        run = "/usr/share/crio/start.sh";
        conditions = [
          {
            key = "Container runtime";
            value = "cri-o";
          }
        ];
      };
    };
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
            "cilium"
          ];
        }
      ];
    };
  };
}
