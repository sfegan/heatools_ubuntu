# heatools_ubuntu
Docker build of HEASOFT tools

- Allow simple installation of binary HEASOFT tools (particularly on Mac) through docker
- Install from docker with :
    ````sh
    docker pull sfegan/heatools_ubuntu:latest
    ````
- Run analysis of data in ~/data using :
    ````sh
    docker -tiv ~/data:/data sfegan/heatools_ubuntu
    cd /data
    <run your hea tool here>
    ````

Includes CALDB for :

- SWIFT UVOTA (goodfiles_swift_uvota_20170130)
