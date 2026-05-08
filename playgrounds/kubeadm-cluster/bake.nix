{
  lib,
  kubeadm,
  kube-dev-machine,
  kubeVersion,
  ...
}:
let
  args = lib.toBuildArgs { inherit kubeVersion; };

  controlPlaneBase = lib.mkTarget {
    name = "control-plane";
    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./images/control-plane;
    contexts = {
      root = kubeadm.targets.main;
    };
    inherit args;
  };

  controlPlane = lib.tagTarget "playgrounds/kubeadm-cluster/control-plane" controlPlaneBase;

  controlPlaneDefaults = lib.tagTarget "playgrounds/kubeadm-cluster/control-plane-defaults" (
    controlPlaneBase
    // {
      name = "control-plane-defaults";
      contexts = {
        root = kubeadm.targets.defaults;
      };
    }
  );

  workerBase = lib.mkTarget {
    name = "worker";
    platforms = [ "linux/amd64" ];
    context = lib.mkContext ./images/worker;
    contexts = {
      root = kubeadm.targets.main;
    };
  };

  worker = lib.tagTarget "playgrounds/kubeadm-cluster/worker" workerBase;

  workerDefaults = lib.tagTarget "playgrounds/kubeadm-cluster/worker-defaults" (
    workerBase
    // {
      name = "worker-defaults";
      contexts = {
        root = kubeadm.targets.defaults;
      };
    }
  );

  main = lib.tagTarget "playgrounds/kubeadm-cluster" (
    lib.mkTarget {
      name = "main";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ./images;
      contexts = {
        root = controlPlane;
      };
    }
  );

  controlPlaneContainerd = controlPlaneBase // {
    name = "control-plane-containerd";
    contexts = {
      root = kubeadm.targets.containerd;
    };
  };

  workerContainerd = workerBase // {
    name = "worker-containerd";
    contexts = {
      root = kubeadm.targets.containerd;
    };
  };

  workerCrio = workerBase // {
    name = "worker-crio";
    contexts = {
      root = kubeadm.targets.crio;
    };
  };

  devMachine = lib.tagTarget "playgrounds/kubeadm-cluster/dev-machine" (
    lib.mkTarget {
      name = "dev-machine";
      platforms = [ "linux/amd64" ];
      context = lib.mkContext ../kubeadm/images/dev-machine;
      contexts = {
        root = kube-dev-machine.targets.default;
      };
    }
  );
in
{
  targets = {
    inherit main worker;
    "control-plane" = controlPlane;
    "control-plane-containerd" = controlPlaneContainerd;
    "control-plane-defaults" = controlPlaneDefaults;
    "worker-defaults" = workerDefaults;
    "worker-containerd" = workerContainerd;
    "worker-crio" = workerCrio;
    "dev-machine" = devMachine;
  };
  groups = {
    default = [
      main
      controlPlane
      worker
      controlPlaneDefaults
      workerDefaults
      devMachine
    ];
  };
}
