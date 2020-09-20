#!/bin/zsh
# set the number of open files to be 1024
ulimit -S -n 1024
# 명령어 라인 도구 설치
echo "Command Line Tools를 설치합니다. "
xcode-select --install

# Homebrew 설치
echo "Homebrew를 설치합니다. "
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH=/usr/local/bin:$PATH

# 빌드 도구들 설치
echo "git, gnupg2를 설치합니다. "
brew install git gnupg2

# 청소 확인
echo -e "android라는 이름과 mount.sh라는 이름을 가진 이 디렉토리의 파일을 모두 제거합니다. 미리 다른 폴더로 이동시켜 주세요. (y/n): "
read yn

# 작업시작
if [ ${yn} = 'y' ]; then
    # 청소 작업
    rm android.*
    rm mount.sh
    # 용량체크
    echo -e "디스크 이미지 크기(안드로이드 풀빌드 시엔 150GB 이상을 권장합니다)를 입력해 주세요. 예시: 4g: "
    read size
    echo "이미지 크기: $size"
    # 디스크 이미지 제작
    hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size ${size} ./android.dmg
    # 마운트
    if [ $(ls android.dmg.sparseimage) = 'android.dmg.sparseimage' ]; then
        hdiutil attach ./android.dmg.sparseimage
        echo 'ulimit -S -n 1024 && hdiutil attach $(dirname $0)/android.dmg.sparseimage' >> ./mount.sh
    elif [ $(ls android.dmg) = 'android.dmg' ]; then
        hdiutil attach ./android.dmg.sparseimage
        echo 'ulimit -S -n 1024 && hdiutil attach $(dirname $0)/android.dmg.sparseimage' >> ./mount.sh
    else
        echo "ERROR: 마운트에 실패했습니다. 스크립트 제작자(cubem10)에게 문의해 주시거나 Issues 탭에 보고해 주세요."
    fi
    
    # mount.sh 실행권한 부여
    chmod +x ./mount.sh
    echo "마운트가 해제되었을 시엔 ./mount.sh 명령어로 다시 마운트 해주시고 빌드하시면 됩니다. \n새로 마운트된 디스크로 이동하셔서 빌드 작업을 진행해 주세요."
# 청소 작업 허용 안되었을때
else
    exit
fi

