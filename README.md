# WAF
Web application firewall for nginx reverse proxy using libmodsecurity and Owasp CRS

## 1. How it works

## 2. Dependencies
- Docker
- Optional
  - Any simple webserver (NPM or Python Webserver)
## 3. How to use
- Clone the repository using `git clone`
- Change the directory to newly cloned repo
- Build the docker image using `docker image`
```
#Clone the repo
$ git clone https://github.com/CurlAnalytics/WAF.git
#Change the directory "WAF"
$ cd WAF/
$ ls
#Find the Dockerfile and build image with the following command
$ docker build --tag curl-waf .

```

