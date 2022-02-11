# 1. BRAM Controller
## 1.1. BRAM Controller와 Block Memory Generator 연결 구성
<img src="./images/bram_controller2.PNG?raw=true" width="150%"/>

## 1.2. BRAM Controller를 이용한 Block Memory에 데이터 쓰기
### 1.2.1. BRAM Controller를 사용하기 위해서 run은 high로 설정
### 1.2.2. idle이 high인 경우에만 쓰기가 가능하다.
### 1.2.3. BRAM Controller를 쓰기 모드로 사용하기 위해서 mode는 high로 유지하고, addr 와 write_data에 데이터를 입력한다.

## 1.3. BRMA Controller를 이용한 Block Memory에 데이터 읽기
### 1.3.1. BRAM Controller를 사용하기 위해서 run은 high로 설정
### 1.3.2.  BRAM Controller를 읽기 모드로 사용하기 위해서 mode는 low로 유지하고, addr에 읽고 싶은 데어터 주소를 입력한다.
### 1.3.3. read_valid 신호가 high이면 read_data에 데이터가 존재한다.
<img src="./images/bram_controller1.PNG?raw=true" width="150%"/>