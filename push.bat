for /f "delims== tokens=1,2" %%G in (.env) do set %%G=%%H

SET TAG=latest

IF NOT [%1]==[] (
SET TAG=%1
)

docker login %GITLAB_HOST% -u %GITLAB_USER% -p %GITLAB_TOKEN%
docker build -t %GITLAB_HOST%%GITLAB_IMAGE%:%TAG% .
docker push %GITLAB_HOST%%GITLAB_IMAGE%:%TAG%
