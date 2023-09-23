import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class LightsailStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // DEBUG: userDataが動いてなさそう
    // 実行ユーザが不明
    // dockerも入ってない
    // でもCDKはエラーで落ちていない
    const userData = `#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
mkdir -p ~/.ssh
wget https://github.com/uta8a.keys > ~/.ssh/authorized_keys`

    const instance = new cdk.aws_lightsail.CfnInstance(this, 'Instance', {
      availabilityZone:'ap-northeast-1a',
      instanceName: 'Instance-1',
      blueprintId: 'ubuntu_22_04',
      bundleId: 'small_3_0',
      userData: userData,
    })

    new cdk.aws_lightsail.CfnStaticIp(this, 'StaticIp-1', {
      staticIpName: 'StaticIp-1',
      attachedTo: instance.instanceName,
    })
  }
}
