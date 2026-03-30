#!/usr/bin/env fish
	
set hosts jinora opal toph iroh
	
for host in $hosts
    echo "Deploying $host"
    ssh $host "sudo nixos-rebuild switch --flake github:chuu-p/nixos#$host"
end
