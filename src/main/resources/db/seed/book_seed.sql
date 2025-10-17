-- ==========================================================
-- book 테이블 데이터
-- ==========================================================
INSERT IGNORE INTO book (book_id, title, publisher, price, isbn, description, category_id) VALUES
(1, '지금처럼 영원히 함께해', '북로그컴퍼니', 23850, '9791168031258', '「촛불 하나」, 「길」, 「사랑해 그리고 기억해」, 「거짓말」 등 세대를 아우른 국민그룹 god의 명곡을 필사로 만나다!', 11),
(2, '당신이 글을 쓰면 좋겠습니다', '북로망스', 17820, '9791192671329', '출간 즉시 예스24 종합 베스트셀러! "베스트셀러 작가 김선우의 글쓰기 영업비밀 대공개!"', 11),
(3, '내 몸 혁명', '올라운드', 19800, '9791198425232', '"운동 없이도, 약 없이도 혈압, 혈당, 콜레스테롤이 싹 사라진다!" ★ 20만 구독 의학 유튜버 고대유 박사의 최강의 식단 공식 ★', 8),
(4, '진짜 나를 만나는 라이팅북', '빅피시', 17820, '9791168341395', '"어떤 어려움 속에서도 나를 지키고 나아갈 힘을 얻게 될 거예요" ★ 1만 명의 삶을 바꾼 화제의 글쓰기 수업, 최초 공개! ★', 11),
(5, '내 안의 백만장자', '다산북스', 17820, '9791130650942', '"절대 부자가 될 수 없는 사람은?" 다음 질문에 하나라도 해당되는 사람!', 11),
(6, '나는 메트로폴리탄 미술관의 경비원입니다', '웅진지식하우스', 15120, '9791169850122', '"나는 그저 여기에 있을 뿐이다" 전 세계를 감동시킨 화제의 회고록', 10),
(7, '해리 포터와 마법사의 돌 1', '문학수첩', 12600, '9788983927694', '20주년 기념 개정판. J. K. 롤링의 첫 소설로, 1997년 영국에서 출간된 후 완간까지 10년 동안 지구촌에 해리 포터 신드롬을 일으킨 작품이다.', 10),
(8, '지적 대화를 위한 넓고 얕은 지식 1', '웨일북', 16200, '9788994105844', '역사, 경제, 정치, 사회, 윤리 전 분야를 망라하는 최소한의 교양. 현실 너머의 세상, 즉 현실 세계를 움직이는 역사의 커다란 흐름을 알려준다.', 11),
(9, '잘될 수밖에 없는 너에게', '알에이치코리아(RHK)', 16920, '9788925578761', '오직 당신의 '잘됨'을 소망하는 작가 이꽃님의 따뜻한 응원의 메시지.', 10),
(10, '최태성의 한눈에 사로잡는 한국사', '들녘', 19800, '9788975276602', '한국사 시험의 모든 것을 담은, 큰별쌤 최태성의 대표 한국사 기본서.', 11),
(11, '나는 당신이 잘됐으면 좋겠습니다', '토네이도', 16020, '9791158511679', '20만 독자의 삶을 바꾼 이은경 작가의 현실 조언. 당신의 잠재력을 깨우고 원하는 삶으로 이끌어 줄 따뜻한 응원과 지지의 메시지.', 10),
(12, '대한항공 50년, 비상(飛上)의 스토리', '알에이치코리아(RHK)', 18000, '9788925567789', '대한항공의 50년 역사를 담은 책. 창업주 조중훈 회장의 경영철학과 대한항공의 성장 스토리를 통해 대한민국 경제 발전사를 엿볼 수 있다.', 11),
(13, '몰입', '알에이치코리아(RHK)', 15300, '9788925532589', '천재들의 학습법, '몰입'을 통해 당신의 잠재력을 100% 끌어내는 방법.', 11),
(14, '세상을 바꾼 10가지 의약품', '사람과나무사이', 16200, '9791188283305', '페니실린부터 비아그라까지, 인류의 역사를 바꾼 위대한 의약품들의 탄생 비화.', 11),
(15, '나는 죽을 때까지 지적이고 싶다', '다산초당', 15120, '9791130616115', '평생 뇌를 건강하고 젊게 유지하는 50가지 방법.', 10),
(16, '회복탄력성', '위즈덤하우스', 15120, '9788960864273', '역경과 시련을 이겨내는 마음의 힘, 회복탄력성을 키우는 방법.', 10),
(17, '마음 챙김의 시', '포레스트북스', 15120, '9791168340459', '힘들고 지칠 때, 시가 건네는 따뜻한 위로. 김성민 아나운서가 전하는 마음 챙김의 시간.', 10),
(18, '여행의 이유', '문학동네', 13320, '9788954655977', '작가 이병률이 전하는 여행의 의미와 그 속에서 발견한 삶의 가치.', 10),
(19, '돈의 속성', '스노우폭스북스', 16020, '9791197142407', '최상위 부자가 말하는 돈에 대한 모든 것. 돈을 다루는 능력, 돈의 본질에 대한 깊이 있는 통찰.', 11),
(20, '지적 대화를 위한 넓고 얕은 지식 0', '웨일북', 16020, '9791190313175', '지적 대화의 출발점. 우주부터 인간까지, 모든 것의 시작에 대한 이야기.', 11),
(21, '나는 단순하게 살기로 했다', '비즈니스북스', 13320, '9788994468642', '물건을 버린 후 찾아온 12가지 인생의 변화.', 10),
(22, '하루 5분, 인생을 바꾸는 습관', '청림Life', 14220, '9788935212359', '건강, 시간, 돈, 관계를 변화시키는 작은 습관의 힘.', 10),
(23, '이기는 대화', '포레스트북스', 15120, '9791168340428', '말 때문에 후회하는 당신을 위한 50가지 대화의 기술.', 11),
(24, '나를 아프게 한 건 항상 나였다', '위즈덤하우스', 15120, '9788960864280', '나를 사랑하고, 나를 지키는 자존감 수업.', 10),
(25, '맡겨진 소녀', '다산책방', 11700, '9791130638551', '아일랜드 작가 클레어 키건의 소설. 낯선 집에 맡겨진 한 소녀의 여름 이야기.', 10),
(26, '어떻게 말해줘야 할까', '김영사', 15750, '9788934988220', '국민 육아 멘토 오은영 박사의 현실 밀착 육아 회화.', 11),
(27, '흔한남매 1', '미래엔아이세움', 12150, '9788937888790', '유쾌한 남매의 일상 속에서 배우는 과학 상식.', 11),
(28, '당신도 느리게 나이 들 수 있습니다', '더퀘스트', 16200, '9791165219757', '서울아산병원 노년내과 정희원 교수가 제안하는 건강하고 행복한 노년의 삶.', 8),
(29, '불변의 법칙', '서삼독', 22500, '9791198527004', '성공과 행복을 위한 23가지 절대 변하지 않는 삶의 지혜.', 10),
(30, '매일매일 좋은 날', '북클라우드', 13500, '9788993357807', '일본의 다도 명인 모리시타 노리코가 전하는 일상 속 행복의 발견.', 10),
(31, '자연이 주는 선물', '테라', 14400, '9791168340442', '에그박사와 함께 떠나는 신비한 자연 탐험.', 11),
(32, '세이노의 가르침', '데이원', 6480, '9791169850719', '당신의 인생을 바꿀 부와 성공에 대한 지혜.', 11),
(33, '별의 길', '김영사', 14220, '9788934991190', '개그맨 양세형, 양세찬 형제가 들려주는 꿈과 희망의 메시지.', 10),
(34, '나는 나로 살기로 했다', '마음의숲', 13320, '9791187119865', '나를 지키며 살아가는 법. 어른이 되어 처음 만나는 나를 위한 심리학.', 10),
(35, '말의 품격', '북클라우드', 14400, '9788993357982', '말과 사람과 품격에 대한 생각들.', 10),
(36, '대통령의 글쓰기', '메디치미디어', 14400, '9788994612307', '김대중, 노무현 대통령에게 배우는 사람을 움직이는 글쓰기 비법.', 11),
(37, '강성태 66일 공부법', '다산북스', 13500, '9791130610335', '공부의 신 강성태가 알려주는 습관을 만드는 66일 공부법.', 11),
(38, '설민석의 조선왕조실록', '세계사', 20700, '9788933870634', '조선 500년 역사를 한 권으로 읽는, 설민석의 명쾌한 역사 강의.', 11),
(39, '아주 작은 습관의 힘', '비즈니스북스', 14400, '9791162540640', '최고의 변화는 어떻게 만들어지는가. 인생을 바꾸는 핵심 습관 설명서.', 10),
(40, '역행자', '웅진지식하우스', 15750, '9791169850023', '인생의 자유와 경제적 자유를 얻는 7단계 인생 공략집.', 11),
(41, '라틴어 수업', '흐름출판', 14400, '9788965961668', '지적이고 아름다운 삶을 위한.', 11),
(42, '말 그릇', '카시오페아', 14400, '9788994727142', '비울수록 사람을 더 채우는.', 10),
(43, '모든 것은 기본에서 시작한다', '수오서재', 15120, '9791191891217', '손흥민의 아버지, 손웅정 감독의 인생 철학.', 10),
(44, '1억이 아니라 100억을 벌고 싶다면', '다산북스', 17820, '9791130649779', '부의 그릇을 키우는 생각의 전환.', 11),
(45, '공간이 만든 공간', '을유문화사', 15120, '9788932474421', '건축가 유현준이 들려주는 도시와 건축 이야기.', 11),
(46, '알로하, 나의 엄마들', '북하우스', 14220, '9791164050474', '하와이 이민 1세대 여성들의 삶과 사랑, 그리고 연대.', 10),
(47, '나는 너에게 좋은 사람이고 싶다', '위즈덤하우스', 15120, '9788960864297', '관계에 지친 당신을 위한 심리학.', 10),
(48, '과학콘서트', '동아시아', 16200, '9788988165798', '복잡한 세상, 명쾌한 과학. 정재승의 크로스 사이언스.', 11),
(49, '학문의 즐거움', '김영사', 8910, '9788934903339', '수학의 노벨상, 필즈상 수상자 히로나카 헤이스케의 자전적 이야기.', 10),
(50, '인생수업', '더퀘스트', 14220, '9791165219764', '법륜 스님과 이광수가 함께한 인생 이야기.', 10),
(51, '지금 이대로 좋다', '정토출판', 12600, '9788985961817', '법륜 스님의 행복론.', 10),
(52, '내가 틀릴 수도 있습니다', '다산초당', 14400, '9791130635482', '숲속의 현자가 전하는 마지막 지혜.', 10),
(53, '쎈멘탈', '다산북스', 16200, '9791130643753', '어떤 상황에서도 무너지지 않는 강한 정신력의 비밀.', 10),
(54, '엄마의 말하기 연습', '카시오페아', 13500, '9788994727159', '아이의 마음을 여는 공감 대화법.', 11),
(55, '블로노트', '달', 12420, '9788996991368', '타블로의 감성적인 문장들.', 10),
(56, '트렌드 코리아 2023', '미래의창', 17100, '9788959897258', '2023년 대한민국 소비 트렌드 전망.', 11),
(57, '시민의 교양', '웨일북', 15300, '9788994105950', '당신이 알아야 할 최소한의 현대 교양.', 11),
(58, '대통령의 말하기', '위즈덤하우스', 14400, '9788960863269', '노무현 대통령에게 배우는 사람을 움직이는 소통의 기술.', 11),
(59, '말하다', '문학동네', 13050, '9788954622870', '김영하 작가의 강연집. 소설가, 여행가, 이야기꾼으로서의 삶과 생각.', 11),
(60, '어떻게 살 것인가', '생각의길', 15750, '9788965132204', '유시민의 인생 특강. 삶의 의미와 방향을 묻는 이들에게.', 10),
(61, '골든아워 1', '흐름출판', 13950, '9788965962825', '생과 사의 경계, 중증외상센터의 기록.', 10),
(62, '그들이 말하지 않는 23가지', '부키', 16200, '9788960511212', '장하준 교수의 유쾌한 경제학 뒤집어 보기.', 11),
(63, '나는 내 파이를 구할 뿐 인류를 구하러 온 게 아니라고', '창비', 15300, '9791191259581', '장애여성공감 활동가 홍은전의 에세이.', 10),
(64, '만화로 보는 감정의 정리', '다산코믹스', 12600, '9791130616122', '부정적인 감정을 긍정적으로 바꾸는 27가지 방법.', 10),
(65, '당신이 옳다', '해냄출판사', 14220, '9788965746357', '정신과 의사 정혜신이 전하는 究極の 공감.', 10),
(66, '무례한 사람에게 웃으며 대처하는 법', '가나출판사', 12420, '9788957369912', '회사, 가족, 친구에게 더는 상처받고 싶지 않은 사람들을 위한 관계 심리학.', 10),
(67, '1초 만에 흔드는 스피치', '북로그컴퍼니', 13500, '9791185853245', '사람의 마음을 사로잡는 말하기의 모든 것.', 11),
(68, '나의 하루는 4시 30분에 시작된다', '토네이도', 13500, '9791158511686', '새벽 기상이 선사하는 인생의 기적.', 10),
(69, '관점을 디자인하라', '프롬북스', 13500, '9788993438342', '당연한 것을 의심하고, 새로운 시각으로 세상을 바라보는 법.', 11),
(70, '시가 나에게로 왔다', '마음산책', 12600, '9788960900223', '신경림 시인이 가려 뽑은 아름다운 시 모음.', 10),
(71, '사랑하라 한번도 상처받지 않은 것처럼', '오래된미래', 9000, '9788995501431', '류시화가 엮은 잠언 시집.', 10),
(72, '꽃을 보듯 너를 본다', '지혜', 9000, '9788993106367', '나태주 시인의 시집. 풀꽃 같은 너에게 보내는 따뜻한 시선.', 10),
(73, '어쩌면 별들이 너의 슬픔을 가져갈지도 몰라', '위즈덤하우스', 12420, '9788960862996', '김용택 시인이 권하는 따라 쓰고 싶은 시 101.', 10),
(74, '내가 사랑하는 시', '해냄출판사', 11700, '9788965740447', '장석주 시인이 고른 사랑과 인생의 시.', 10),
(75, '섬진강', '창비', 7200, '9788936420551', '김용택 시인의 대표 시집. 섬진강의 자연과 사람들의 삶을 노래.', 10),
(76, '너에게 난', '시와에세이', 10800, '9788992254303', '용혜원 시인의 사랑 시 모음.', 10),
(77, '연어', '문학동네', 8100, '9788982813426', '어른을 위한 동화. 은빛 연어의 일생을 통해 배우는 삶의 지혜.', 10),
(78, '해에게서 소년에게', '문학동네', 8100, '9788982813433', '이해인 수녀가 들려주는 희망의 메시지.', 10),
(79, '너를 기다리는 동안', '문학과지성사', 7200, '9788932005085', '황지우 시인의 대표 시집. 기다림과 사랑, 그리고 시대의 아픔.', 10),
(80, '어린왕자', '인디고(글담)', 9720, '9788991069692', '생텍쥐페리의 고전. 어른이 되어 다시 읽는 어린왕자 이야기.', 10),
(81, '나미야 잡화점의 기적', '현대문학', 13320, '9788972756194', '히가시노 게이고의 장편소설. 과거와 현재가 이어지는 신비한 잡화점.', 10),
(82, '미움받을 용기', '인플루엔셜', 13410, '9788996991344', '아들러 심리학을 바탕으로 한 자유롭고 행복한 삶을 위한 안내서.', 10),
(83, '데일 카네기 인간관계론', '현대지성', 10350, '97811893482', '인간관계의 바이블. 친구를 만들고 사람을 설득하는 방법.', 11),
(84, '코스모스', '사이언스북스', 16650, '9788983711892', '칼 세이건이 들려주는 우주와 생명, 그리고 인간에 대한 이야기.', 11),
(85, '사피엔스', '김영사', 19800, '9788934972465', '유발 하라리의 인류 역사 대서사. 인간은 어떻게 지구의 지배자가 되었나.', 11),
(86, '정의란 무엇인가', '김영사', 13500, '9788934938607', '마이클 샌델 교수의 하버드 명강의. 정의에 대한 다양한 관점과 딜레마.', 11),
(87, '총, 균, 쇠', '문학사상사', 25200, '9788970127245', '재레드 다이아몬드가 밝히는 지난 13,000년간의 인류 문명사.', 11),
(88, '이기적 유전자', '을유문화사', 16200, '9788932471635', '리처드 도킨스의 혁명적 저작. 유전자의 관점에서 본 생명의 진화.', 11),
(89, '부분과 전체', '서커스', 15120, '9791185599549', '양자역학의 선구자 베르너 하이젠베르크의 자서전.', 10),
(90, '엔트로피', '세종서적', 16200, '9788984071330', '제레미 리프킨이 제시하는 새로운 세계관. 에너지와 문명의 미래.', 11),
(91, '오래된 미래', '중앙북스', 13500, '9788927803622', '헬레나 노르베리 호지의 라다크로부터 배우는 행복의 지혜.', 10),
(92, '죽음의 수용소에서', '청아출판사', 10800, '9788936807184', '빅터 프랭클의 로고테라피. 극한의 상황 속에서 삶의 의미를 찾다.', 10),
(93, '아픔이 길이 되려면', '동아시아', 15120, '9788962621876', '김승섭 교수가 들려주는 사회와 건강, 그리고 치유의 이야기.', 10),
(94, '열한 계단', '창비', 14400, '9791186638111', '채사장의 지적 성장 에세이.', 10),
(95, '왜 나는 너를 사랑하는가', '청미래', 12420, '9788995383501', '알랭 드 보통의 사랑에 대한 철학적 탐구.', 10),
(96, '낭만적 연애와 그 후의 일상', '은행나무', 13050, '9788956609951', '알랭 드 보통이 말하는 사랑과 결혼, 그리고 관계의 본질.', 10),
(97, '채식주의자', '창비', 10800, '9788936433599', '한강의 맨부커상 수상작. 폭력과 욕망, 그리고 구원에 대한 이야기.', 10),
(98, '소년이 온다', '창비', 11700, '9788936434121', '한강의 장편소설. 5.18 광주 민주화 운동을 다룬 이야기.', 10),
(99, '실버인지 속담놀이 워크북', '한국실버교육협회', 10800, '9791197307904', '속담을 통해 노인들의 인지능력 및 언어능력을 향상시키는 워크북.', 9),
(100, '니트 손뜨개', '미호', 13500, '9791165792725', '일본의 인기 니트 작가 도카이 에리카의 첫 배색뜨기 도안집.', 11),
(101, '트렌드 코리아 2026', '미래의창', 18000, '9791193638859', '대한민국 No.1 트렌드서, 준비된 2026년을 위한 최고의 선택!', 14),
(104, '돈의 심리학', '인플루엔셜', 17820, '9791168340435', '당신은 돈에 관해 무엇을 알고 있는가', 12),
(106, '더 해빙 The Having', '수오서재', 14400, '9791191891279', '부와 행운을 끌어당기는 힘', 12),
(108, '웰씽킹', '다산북스', 16200, '9791130638728', '부를 창조하는 생각의 뿌리', 12),
(109, '돈의 신에게 배우는 머니 시크릿', '다산북스', 16200, '9791130646587', '가장 빠르게 부자 되는 법', 12),
(110, '레버리지', '다산북스', 14400, '9791130616429', '최소 노력으로 최대 효과를 내는 힘', 15),
(111, '부동산 상승신호 하락신호', '알에이치코리아(RHK)', 18000, '9788925577030', '부동산 사이클과 유망 지역 분석', 12),
(112, '대한민국 부동산 7가지 질문', '오픈노트', 17100, '9791168220041', '부동산 시장의 핵심을 꿰뚫는 7가지 질문', 12),
(113, '2025-2027 대한민국 부동산 미래지도', '길벗', 17820, '9791140706599', '미래 가치가 높은 부동산 투자처 분석', 12),
(114, '송사무장의 실전경매', '지혜로', 26100, '9791191118352', '경매 초보를 위한 실전 투자 가이드', 12),
(115, '나는 대치동 학원가에서 교육을 쇼핑한다', '포레스트북스', 17820, '9791168341647', '성공적인 입시 전략과 교육 쇼핑 노하우', 14),
(116, '에이트', '차이정원', 15300, '9788998548999', '인공지능에게 대체되지 않는 나를 만드는 법', 14),
(117, '메리골드 마음 세탁소', '북로망스', 13500, '9791192671190', '지친 마음을 위로하는 따뜻한 이야기', 15),
(118, '문해력 수업', '블랙피쉬', 15120, '9791160023961', '모든 공부의 기초가 되는 문해력 향상법', 14),
(119, '공부의 신', '다산북스', 14400, '9791130602330', '공부의 본질과 최고의 공부법', 15),
(120, '된다! 엑셀 파워포인트 워드', '이지스퍼블리싱', 20700, '9791163032598', '직장인을 위한 오피스 실무 능력 향상', 13),
(121, 'Do it! HTML+CSS+자바스크립트 웹 표준의 정석', '이지스퍼블리싱', 27000, '9791163031140', '웹 개발 입문자를 위한 필독서', 13),
(122, '알고리즘, 인생을 계산하다', '와이즈베리', 16200, '9788984078513', '알고리즘으로 배우는 문제 해결 능력', 14),
(123, '머신러닝', '한빛미디어', 31500, '9791162242131', '인공지능의 핵심, 머신러닝의 모든 것', 14),
(124, '위기관리 커뮤니케이션', '커뮤니케이션북스', 16200, '9791128825852', '기업의 위기를 기회로 바꾸는 소통 전략', 13),
(125, '경제의 99%는 환율이다', '원앤원북스', 15120, '9788960606019', '환율로 세계 경제의 흐름을 읽는 법', 12),
(126, '부의 대이동', '페이지2북스', 15300, '9791196831080', '거시 경제의 흐름과 투자 인사이트', 12),
(127, '돈의 역사', '비즈니스북스', 16200, '9791162540657', '돈의 흐름으로 읽는 세계 경제사', 12),
(128, '50대 사건으로 보는 돈의 역사', '로크미디어', 16200, '9791128300588', '세계사를 바꾼 돈에 관한 50가지 이야기', 12),
(129, '긴축', '비즈니스북스', 16200, '9791162540664', '세계 경제의 미래를 전망하는 키워드', 12),
(130, '주식투자 무작정 따라하기', '길벗', 16920, '9791165219016', '주식 초보를 위한 최고의 입문서', 12),
(131, '투자의 태도', '에프엔미디어', 16200, '9791160073287', '성공하는 투자를 위한 마음가짐과 원칙', 12),
(132, '돈, 뜨겁게 사랑하고 차갑게 다루어라', '미래의창', 10800, '9788959890327', '투자의 대가가 전하는 돈에 대한 지혜', 12),
(133, '전설로 떠나는 월가의 영웅', '국일증권경제연구소', 22500, '9788959891157', '피터 린치의 투자 철학과 전략', 12),
(134, '현명한 투자자', '국일증권경제연구소', 27000, '9788959890945', '가치 투자의 바이블', 12),
(135, '위대한 기업에 투자하라', '굿모닝북스', 10800, '9788996536644', '성장주 투자의 정석', 12),
(136, '원칙', '한빛비즈', 29700, '9791157841415', '인생과 일을 관통하는 레이 달리오의 원칙', 15),
(137, '21세기 자본', '글항아리', 34200, '9788967351408', '불평등에 대한 기념비적인 연구', 14),
(138, '국부론', '동서문화사', 10800, '9788949704221', '자본주의의 작동 원리를 밝힌 고전', 14),
(141, '넛지', '리더스북', 17820, '9791160023954', '똑똑한 선택을 이끄는 힘', 13),
(142, '생각에 관한 생각', '김영사', 22500, '9788934957592', '인간의 두 가지 사고 시스템에 대한 탐구', 14),
(143, '경제학 콘서트', '웅진지식하우스', 14220, '9788901235372', '일상에서 만나는 경제학의 지혜', 14),
(144, '어쩌다 어른', '알에이치코리아(RHK)', 14400, '9788925560933', '인지심리학으로 풀어보는 인간 마음의 비밀', 15),
(146, '거의 모든 것의 역사', '까치', 22500, '9788972913645', '우주와 생명, 그리고 인간에 대한 모든 것', 14),
(147, '아웃라이어', '김영사', 13500, '9788934931882', '성공의 기회를 발견하는 특별한 법칙', 15),
(148, '습관의 힘', '웅진지식하우스', 14400, '9788901142540', '우리의 인생을 지배하는 습관의 비밀', 15),
(149, '마인드셋', '스몰빅라이프', 16200, '9791188338319', '성공과 실패를 결정하는 마음가짐의 힘', 15),
(150, '그릿', '비즈니스북스', 14400, '9791186720703', '재능보다 중요한 열정적 끈기의 힘', 15),
(151, '나는 왜 이 일을 하는가?', '비즈니스북스', 13500, '9788997576483', '사람들을 움직이는 리더십의 핵심', 14),
(152, '오리지널스', '한국경제신문', 15120, '9788947540456', '순응하지 않는 사람들이 세상을 움직인다', 14),
(153, '리워크', '21세기북스', 13500, '9788950923005', '더 똑똑하고, 더 빠르고, 더 쉽게 일하는 법', 14),
(154, '꿈꾸는 다락방', '국일미디어', 13500, '9788974255193', '생생하게 꿈꾸면 현실이 된다', 15),
(155, '12가지 인생의 법칙', '메이븐', 15120, '9791196067623', '혼돈의 시대를 살아가는 우리를 위한 지침서', 15),
(156, '놓치고 싶지 않은 나의 꿈 나의 인생', '북이십일', 11700, '9788989548483', '성공 철학의 거장이 전하는 꿈을 이루는 비결', 15),
(157, '데일 카네기 인간관계론', '현대지성', 10350, '9791189348210', '시대를 초월한 인간관계의 바이블', 15),
(158, '성공하는 사람들의 7가지 습관', '김영사', 14220, '9788934913383', '인생을 바꾸는 성공 습관의 모든 것', 15),
(159, '부자 아빠 가난한 아빠', '민음인', 14400, '9791196314319', '금융 지능을 일깨워주는 부자들의 돈 관리법', 12),
(160, 'EBS 자본주의', '가나출판사', 14400, '9788957365617', '돈의 비밀을 파헤치는 자본주의 사용 설명서', 14),
(161, '절창 切創', '문학동네', 16200, '9791141602451', '상처를 통해 타인을 읽는 한 여인, 그리고 타인이라는 영원한 텍스트', 16),
(162, '혼모노', '창비', 16200, '9788936439743', '"'몰입'의 파티다. 영화로 만들고 싶은 작품들로 가득하다." -배우 박정민', 16),
(163, '쇼코의 미소', '문학동네', 12150, '9788954641796', '젊은작가상 대상 수상작 「쇼코의 미소」 수록!', 16),
(164, '도시와 그 불확실한 벽', '문학동네', 17550, '9791141601959', '무라카미 하루키 6년 만의 신작 장편소설!', 17),
(165, '작별하지 않는다', '문학동네', 13500, '9788954682157', '한강 신작 장편소설, 제주 4·3을 품다', 16),
(166, '개미', '은행나무', 15120, '9788956608923', '베르나르 베르베르의 전설적인 데뷔작!', 17),
(167, '아버지의 해방일지', '창비', 13500, '9788936438945', '우리 시대 '아버지'들의 초상, 유쾌하고 따뜻하게 그려내다', 16),
(168, '지구 끝의 온실', '밀리의서재', 13500, '9791191043262', '한국형 SF의 새로운 길을 연 김초엽의 첫 장편소설', 19),
(169, '하얼빈', '문학동네', 14400, '9788954692255', '김훈 장편소설, 안중근의 짧고 강렬했던 생애', 16),
(171, '밝은 밤', '문학동네', 13050, '9788954676941', '백 년의 시간을 건너온 네 여자의 이야기', 16),
(172, '아몬드', '창비', 11700, '9788936434268', '감정을 느끼지 못하는 소년의 특별한 성장 이야기', 16),
(173, '살인자의 기억법', '문학동네', 10800, '9788954622030', '알츠하이머에 걸린 연쇄살인범의 마지막 기록', 19),
(174, '달러구트 꿈 백화점', '팩토리나인', 12420, '9791165341908', '잠들어야만 입장 가능한 꿈 백화점의 비밀', 19),
(175, '너의 안부를 묻는 밤', '시드앤페이퍼', 13320, '9791196025913', '지친 하루 끝에 따뜻한 위로를 건네는 감성 에세이', 18),
(176, '불편한 편의점', '나무옆의자', 12600, '9791161571188', '힘들게 살아가는 우리 이웃들의 희로애락', 16),
(177, '일의 기쁨과 슬픔', '창비', 12600, '9788936438150', '현실과 상상을 넘나드는 기발한 이야기들', 16),
(182, '중국식 룰렛', '문학동네', 11700, '9788954619481', '오정희 소설가가 들려주는 인생의 단편', 16),
(186, '데미안', '민음사', 7200, '9788937460117', '알을 깨고 나오는 새처럼, 고통스러운 성장의 기록', 17),
(187, '1984', '민음사', 9000, '9788937462104', '빅브라더가 지배하는 감시 사회에 대한 예언', 17),
(188, '위대한 개츠비', '민음사', 7200, '9788937460834', '화려한 아메리칸드림, 그 이면의 공허와 비극', 17),
(189, '노인과 바다', '민음사', 7200, '9788937460841', '인간의 불굴의 의지를 그린 장엄한 서사', 17),
(190, '이방인', '민음사', 7200, '9788937460018', '부조리한 세상 속, 낯선 존재로 살아가는 이의 이야기', 17),
(191, '참을 수 없는 존재의 가벼움', '민음사', 10800, '9788937482614', '사랑과 역사 속에서 존재의 의미를 묻다', 17),
(192, '백 년의 고독', '민음사', 13500, '9788937480535', '한 가문의 흥망성쇠를 통해 본 라틴 아메리카의 역사', 17),
(193, '호밀밭의 파수꾼', '민음사', 8100, '9788937460599', '위선적인 세상에 대한 청춘의 저항과 방황', 17),
(194, '인간 실격', '민음사', 5400, '9788937461244', '세상과 화해하지 못한 한 남자의 처절한 고백', 17),
(195, '주홍색 연구', '더스토리', 2680, '9791175240438', '셜록 홈즈 시리즈의 첫 번째 장편소설', 19);

-- 컬럼 데이터 추가
UPDATE book SET registration_date = '2025-10-22', page_count = 256, width = 150, height = 215, thumbnail_url = 'https://image.yes24.com/goods/154828685/XL', isbn = '9791168031258' WHERE book_id = 1;
UPDATE book SET registration_date = '2020-01-30', page_count = 288, width = 135, height = 205, thumbnail_url = 'https://image.yes24.com/goods/86592319/XL', isbn = '9791190030328' WHERE book_id = 2;
UPDATE book SET registration_date = '2024-01-10', page_count = 336, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/124225606/XL', isbn = '9791198553317' WHERE book_id = 3;
UPDATE book SET registration_date = '2019-02-05', page_count = 284, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/69254045/XL', isbn = '9791189432379' WHERE book_id = 4;
UPDATE book SET registration_date = '2002-12-31', page_count = 300, width = NULL, height = NULL, thumbnail_url = 'https://image.yes24.com/goods/323385/XL', isbn = '9788995222638' WHERE book_id = 5;
UPDATE book SET registration_date = '2025-09-25', page_count = 368, width = 135, height = 210, thumbnail_url = 'https://image.yes24.com/goods/154168402/XL', isbn = '9788901297453' WHERE book_id = 6;
UPDATE book SET registration_date = '2024-11-20', page_count = 248, width = 137, height = 195, thumbnail_url = 'https://image.yes24.com/goods/136727687/XL', isbn = '9791193790403' WHERE book_id = 7;
UPDATE book SET registration_date = '2020-02-01', page_count = 388, width = 152, height = 210, thumbnail_url = 'https://image.yes24.com/goods/86545658/XL', isbn = '9791190313186' WHERE book_id = 8;
UPDATE book SET registration_date = '2022-08-18', page_count = 272, width = 130, height = 190, thumbnail_url = 'https://image.yes24.com/goods/111750543/XL', isbn = '9791191891201' WHERE book_id = 9;
UPDATE book SET registration_date = '2011-07-08', page_count = 557, width = 174, height = 224, thumbnail_url = 'https://image.yes24.com/goods/5325535/XL', isbn = '9788975278730' WHERE book_id = 10;
UPDATE book SET registration_date = '2018-02-08', page_count = 240, width = 136, height = 200, thumbnail_url = 'https://image.yes24.com/goods/58544168/XL', isbn = '9791187192787' WHERE book_id = 11;
UPDATE book SET registration_date = '2024-05-01', page_count = 456, width = 152, height = 220, thumbnail_url = 'https://image.yes24.com/goods/126160327/XL', isbn = '9788925575025' WHERE book_id = 13;
UPDATE book SET registration_date = '2018-05-10', page_count = 251, width = 142, height = 216, thumbnail_url = 'https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791188635108.jpg', isbn = '9791188635108' WHERE book_id = 14;
UPDATE book SET registration_date = '2023-06-15', page_count = 276, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/119459107/XL', isbn = '9791191669466' WHERE book_id = 15;
UPDATE book SET registration_date = '2019-03-29', page_count = 268, width = 148, height = 210, thumbnail_url = 'https://image.yes24.com/goods/71743513/XL', isbn = '9791189938772' WHERE book_id = 16;
UPDATE book SET registration_date = '2020-09-17', page_count = 184, width = 122, height = 206, thumbnail_url = 'https://image.yes24.com/goods/92462696/XL', isbn = '9791190382267' WHERE book_id = 17;
UPDATE book SET registration_date = '2024-04-17', page_count = 260, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/125905365/XL', isbn = '9791191114591' WHERE book_id = 18;
UPDATE book SET registration_date = '2020-06-15', page_count = 415, width = 152, height = 215, thumbnail_url = 'https://image.yes24.com/goods/90428162/XL', isbn = '9791188331796' WHERE book_id = 19;
UPDATE book SET registration_date = '2019-12-24', page_count = 556, width = 152, height = 210, thumbnail_url = 'https://image.yes24.com/goods/84659792/XL', isbn = '9791190313131' WHERE book_id = 20;
UPDATE book SET registration_date = '2015-12-10', page_count = 276, width = 150, height = 215, thumbnail_url = 'https://image.yes24.com/goods/23208678/XL', isbn = '9791186805114' WHERE book_id = 21;
UPDATE book SET registration_date = '2010-12-20', page_count = 222, width = 152, height = 224, thumbnail_url = 'https://image.yes24.com/goods/4489774/XL', isbn = '9788994648033' WHERE book_id = 22;
UPDATE book SET registration_date = '2024-08-16', page_count = 148, width = 169, height = 225, thumbnail_url = 'https://image.yes24.com/goods/129601755/XL', isbn = '9791193221150' WHERE book_id = 23;
UPDATE book SET registration_date = '2022-05-02', page_count = 264, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/109004969/XL', isbn = '9791191731217' WHERE book_id = 24;
UPDATE book SET registration_date = '2023-04-26', page_count = 104, width = 132, height = 192, thumbnail_url = 'https://image.yes24.com/goods/118569079/XL', isbn = '9791130698199' WHERE book_id = 25;
UPDATE book SET registration_date = '2021-09-10', page_count = 208, width = 197, height = 266, thumbnail_url = 'https://image.yes24.com/goods/103855469/XL', isbn = '9788934907749' WHERE book_id = 26;
UPDATE book SET registration_date = '2019-06-20', page_count = 164, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/74298443/XL', isbn = '9791164131686' WHERE book_id = 27;
UPDATE book SET registration_date = '2023-01-17', page_count = 288, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/116413548/XL', isbn = '9791140702589' WHERE book_id = 28;
UPDATE book SET registration_date = '2024-02-28', page_count = 420, width = 145, height = 217, thumbnail_url = 'https://image.yes24.com/goods/124999476/XL', isbn = '9791198517425' WHERE book_id = 29;
UPDATE book SET registration_date = '2019-01-09', page_count = 288, width = 130, height = 210, thumbnail_url = 'https://image.yes24.com/goods/67618149/XL', isbn = '9788925565071' WHERE book_id = 30;
UPDATE book SET registration_date = '2017-09-19', page_count = 36, width = 215, height = 280, thumbnail_url = 'https://image.yes24.com/goods/45873453/XL', isbn = '9791188154104' WHERE book_id = 31;
UPDATE book SET registration_date = '2023-03-02', page_count = 736, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/117014613/XL', isbn = '9791168473690' WHERE book_id = 32;
UPDATE book SET registration_date = '2023-12-04', page_count = 180, width = 130, height = 200, thumbnail_url = 'https://image.yes24.com/goods/123930960/XL', isbn = '9791198744470' WHERE book_id = 33;
UPDATE book SET registration_date = '2023-02-04', page_count = 312, width = 140, height = 190, thumbnail_url = 'https://image.yes24.com/goods/106540460/XL', isbn = '9791197377150' WHERE book_id = 34;
UPDATE book SET registration_date = '2023-01-27', page_count = 232, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/117250273/XL', isbn = '9791167913128' WHERE book_id = 35;
UPDATE book SET registration_date = '2024-04-10', page_count = 376, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/125816942/XL', isbn = '9791157063482' WHERE book_id = 36;
UPDATE book SET registration_date = '2019-06-18', page_count = 328, width = 148, height = 215, thumbnail_url = 'https://image.yes24.com/goods/33297297/XL', isbn = '9791130610283' WHERE book_id = 37;
UPDATE book SET registration_date = '2016-07-25', page_count = 504, width = 165, height = 235, thumbnail_url = 'https://image.yes24.com/goods/29433467/XL', isbn = '9788933870693' WHERE book_id = 38;
UPDATE book SET registration_date = '2019-02-26', page_count = 360, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/69655504/XL', isbn = '9791162540640' WHERE book_id = 39;
UPDATE book SET registration_date = '2022-05-30', page_count = 314, width = 148, height = 195, thumbnail_url = 'https://image.yes24.com/goods/109705390/XL', isbn = '9788901260716' WHERE book_id = 40;
UPDATE book SET registration_date = '2023-08-15', page_count = 356, width = 145, height = 225, thumbnail_url = 'https://image.yes24.com/goods/121912222/XL', isbn = '9788965965879' WHERE book_id = 41;
UPDATE book SET registration_date = '2017-09-22', page_count = 320, width = 140, height = 205, thumbnail_url = 'https://image.yes24.com/goods/46659527/XL', isbn = '9791185952987' WHERE book_id = 42;
UPDATE book SET registration_date = '2021-10-15', page_count = 284, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/104086365/XL', isbn = '9791190382502' WHERE book_id = 43;
UPDATE book SET registration_date = '2020-04-30', page_count = 416, width = 142, height = 195, thumbnail_url = 'https://image.yes24.com/goods/89969235/XL', isbn = '9788932474274' WHERE book_id = 45;
UPDATE book SET registration_date = '2020-03-25', page_count = 392, width = 152, height = 210, thumbnail_url = 'https://image.yes24.com/goods/89746358/XL', isbn = '9788936456955' WHERE book_id = 46;
UPDATE book SET registration_date = '2021-10-08', page_count = 292, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/104102197/XL', isbn = '9791191043433' WHERE book_id = 47;
UPDATE book SET registration_date = '2020-07-07', page_count = 388, width = 145, height = 217, thumbnail_url = 'https://image.yes24.com/goods/90959711/XL', isbn = '9791190030540' WHERE book_id = 48;
UPDATE book SET registration_date = '2008-07-28', page_count = 238, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/243767/XL', isbn = '9788934930662' WHERE book_id = 49;
UPDATE book SET registration_date = '2024-12-09', page_count = 312, width = 150, height = 210, thumbnail_url = 'https://image.yes24.com/goods/139752587/XL', isbn = '9791187297789' WHERE book_id = 50;
UPDATE book SET registration_date = '2019-10-30', page_count = 272, width = 137, height = 200, thumbnail_url = 'https://image.yes24.com/goods/80739168/XL', isbn = '9791187297239' WHERE book_id = 51;
UPDATE book SET registration_date = '2024-01-08', page_count = 320, width = 132, height = 200, thumbnail_url = 'https://image.yes24.com/goods/108850617/XL', isbn = '9791130689890' WHERE book_id = 52;
UPDATE book SET registration_date = '2016-04-11', page_count = 240, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/25752933/XL', isbn = '9788961094856' WHERE book_id = 53;
UPDATE book SET registration_date = '2018-02-26', page_count = 280, width = 150, height = 210, thumbnail_url = 'https://image.yes24.com/goods/58998723/XL', isbn = '9791188007134' WHERE book_id = 54;
UPDATE book SET registration_date = '2016-09-28', page_count = 256, width = 124, height = 185, thumbnail_url = 'https://image.yes24.com/goods/32387212/XL', isbn = '9791158160432' WHERE book_id = 55;
UPDATE book SET registration_date = '2022-10-05', page_count = 424, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/113416767/XL', isbn = '9788959897094' WHERE book_id = 56;
UPDATE book SET registration_date = '2015-12-31', page_count = 348, width = 148, height = 210, thumbnail_url = 'https://image.yes24.com/goods/23510873/XL', isbn = '9791195677108' WHERE book_id = 57;
UPDATE book SET registration_date = '2016-08-24', page_count = 328, width = 148, height = 215, thumbnail_url = 'https://image.yes24.com/goods/30569459/XL', isbn = '9788960869707' WHERE book_id = 58;
UPDATE book SET registration_date = '2015-03-11', page_count = 252, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/16880264/XL', isbn = '9788954635356' WHERE book_id = 59;
UPDATE book SET registration_date = '2013-03-13', page_count = 344, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/8491738/XL', isbn = '9788965132288' WHERE book_id = 60;
UPDATE book SET registration_date = '2024-10-03', page_count = 488, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/133846643/XL', isbn = '9788965966524' WHERE book_id = 61;
UPDATE book SET registration_date = '2023-03-30', page_count = 368, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/117985784/XL', isbn = '9788960519756' WHERE book_id = 62;
UPDATE book SET registration_date = '2019-04-08', page_count = 164, width = 122, height = 190, thumbnail_url = 'https://image.yes24.com/goods/71864986/XL', isbn = '9791189932084' WHERE book_id = 63;
UPDATE book SET registration_date = '2018-10-10', page_count = 316, width = 145, height = 217, thumbnail_url = 'https://image.yes24.com/goods/64694842/XL', isbn = '9788965746669' WHERE book_id = 65;
UPDATE book SET registration_date = '2023-04-16', page_count = 268, width = 130, height = 188, thumbnail_url = 'https://image.yes24.com/goods/118303541/XL', isbn = '9791192625355' WHERE book_id = 66;
UPDATE book SET registration_date = '2020-10-20', page_count = 256, width = 138, height = 200, thumbnail_url = 'https://image.yes24.com/goods/93513663/XL', isbn = '9791158511906' WHERE book_id = 68;
UPDATE book SET registration_date = '2025-05-02', page_count = 396, width = 152, height = 218, thumbnail_url = 'https://image.yes24.com/goods/145579042/XL', isbn = '9791194755159' WHERE book_id = 69;
UPDATE book SET registration_date = '2023-10-23', page_count = 232, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/123199461/XL', isbn = '9791130820941' WHERE book_id = 70;
UPDATE book SET registration_date = '2005-03-30', page_count = 158, width = 132, height = 215, thumbnail_url = 'https://image.yes24.com/goods/1472519/XL', isbn = '9788995501474' WHERE book_id = 71;
UPDATE book SET registration_date = '2015-06-20', page_count = 184, width = 130, height = 225, thumbnail_url = 'https://image.yes24.com/goods/24259730/XL', isbn = '9791157280292' WHERE book_id = 72;
UPDATE book SET registration_date = '2005-05-19', page_count = 138, width = 135, height = 210, thumbnail_url = 'https://image.yes24.com/goods/1496396/XL', isbn = '9788946415140' WHERE book_id = 73;
UPDATE book SET registration_date = '2009-10-20', page_count = 149, width = 143, height = 220, thumbnail_url = 'https://image.yes24.com/goods/3582572/XL', isbn = '9788973375844' WHERE book_id = 74;
UPDATE book SET registration_date = '1996-06-30', page_count = 200, width = 125, height = 200, thumbnail_url = 'https://image.yes24.com/goods/61537/XL', isbn = '9788936420468' WHERE book_id = 75;
UPDATE book SET registration_date = '1996-03-02', page_count = 134, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/2593294/XL', isbn = '9788985712682' WHERE book_id = 77;
UPDATE book SET registration_date = '2015-11-10', page_count = 196, width = 210, height = 297, thumbnail_url = 'https://image.yes24.com/goods/23117303/XL', isbn = '9791158520687' WHERE book_id = 78;
UPDATE book SET registration_date = '2016-06-01', page_count = 93, width = 132, height = 210, thumbnail_url = 'https://image.yes24.com/goods/28880415/XL', isbn = '9791186418147' WHERE book_id = 79;
UPDATE book SET registration_date = '2015-10-20', page_count = 136, width = 160, height = 220, thumbnail_url = 'https://image.yes24.com/goods/22431294/XL', isbn = '9788932917245' WHERE book_id = 80;
UPDATE book SET registration_date = '2022-12-19', page_count = 456, width = 135, height = 195, thumbnail_url = 'https://image.yes24.com/goods/116586056/XL', isbn = '9791167901484' WHERE book_id = 81;
UPDATE book SET registration_date = '2022-12-28', page_count = 340, width = 140, height = 205, thumbnail_url = 'https://image.yes24.com/goods/116599423/XL', isbn = '9791168340770' WHERE book_id = 82;
UPDATE book SET registration_date = '2019-10-07', page_count = 352, width = 150, height = 225, thumbnail_url = 'https://image.yes24.com/goods/79297023/XL', isbn = '9791187142560' WHERE book_id = 83;
UPDATE book SET registration_date = '2006-12-20', page_count = 719, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/2312211/XL', isbn = '9788983711892' WHERE book_id = 84;
UPDATE book SET registration_date = '2015-11-23', page_count = 636, width = 152, height = 215, thumbnail_url = 'https://image.yes24.com/goods/23030284/XL', isbn = '9788934972464' WHERE book_id = 85;
UPDATE book SET registration_date = '2014-11-20', page_count = 444, width = 152, height = 224, thumbnail_url = 'https://image.yes24.com/goods/15156691/XL', isbn = '9788937834790' WHERE book_id = 86;
UPDATE book SET registration_date = '2023-05-10', page_count = 784, width = 152, height = 215, thumbnail_url = 'https://image.yes24.com/goods/118755085/XL', isbn = '9788934942467' WHERE book_id = 87;
UPDATE book SET registration_date = '2018-10-20', page_count = 632, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/65067259/XL', isbn = '9788932473901' WHERE book_id = 88;
UPDATE book SET registration_date = '2023-06-15', page_count = 504, width = 128, height = 190, thumbnail_url = 'https://image.yes24.com/goods/119420682/XL', isbn = '9791187295686' WHERE book_id = 89;
UPDATE book SET registration_date = '2015-04-01', page_count = 352, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/17357918/XL', isbn = '9788986698824' WHERE book_id = 90;
UPDATE book SET registration_date = '2015-07-01', page_count = 364, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/2760334/XL', isbn = '9788927806615' WHERE book_id = 91;
UPDATE book SET registration_date = '2005-08-10', page_count = 246, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/1775518/XL', isbn = '9788936803261' WHERE book_id = 92;
UPDATE book SET registration_date = '2017-09-13', page_count = 320, width = 140, height = 215, thumbnail_url = 'https://image.yes24.com/goods/46546539/XL', isbn = '9788962621952' WHERE book_id = 93;
UPDATE book SET registration_date = '2016-12-08', page_count = 416, width = 140, height = 205, thumbnail_url = 'https://image.yes24.com/goods/33511454/XL', isbn = '9791195677153' WHERE book_id = 94;
UPDATE book SET registration_date = '2022-11-10', page_count = 274, width = 135, height = 200, thumbnail_url = 'https://image.yes24.com/goods/115275383/XL', isbn = '9788986836837' WHERE book_id = 95;
UPDATE book SET registration_date = '2016-08-24', page_count = 300, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/30547371/XL', isbn = '9788956608846' WHERE book_id = 96;
UPDATE book SET registration_date = '2022-03-28', page_count = 276, width = 128, height = 194, thumbnail_url = 'https://image.yes24.com/goods/108422348/XL', isbn = '9788936434595' WHERE book_id = 97;
UPDATE book SET registration_date = '2014-05-19', page_count = 216, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/13137546/XL', isbn = '9788936434120' WHERE book_id = 98;
UPDATE book SET registration_date = '2021-01-07', page_count = 80, width = 210, height = 297, thumbnail_url = 'https://image.yes24.com/goods/96639541/XL', isbn = '9791197307904' WHERE book_id = 99;
UPDATE book SET registration_date = '2020-11-16', page_count = 100, width = 210, height = 260, thumbnail_url = 'https://image.yes24.com/goods/95374443/XL', isbn = '9791165792725' WHERE book_id = 100;
UPDATE book SET registration_date = '2025-09-24', page_count = 400, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/153064968/XL', isbn = '9791193638859' WHERE book_id = 101;
UPDATE book SET registration_date = '2021-01-13', page_count = 396, width = 140, height = 210, thumbnail_url = 'https://image.yes24.com/goods/96547408/XL', isbn = '9791191056372' WHERE book_id = 104;
UPDATE book SET registration_date = '2025-07-31', page_count = 356, width = 134, height = 204, thumbnail_url = 'https://image.yes24.com/goods/149847223/XL', isbn = '9791198890122' WHERE book_id = 106;
UPDATE book SET registration_date = '2021-11-10', page_count = 316, width = 130, height = 200, thumbnail_url = 'https://image.yes24.com/goods/104866527/XL', isbn = '9791130677774' WHERE book_id = 108;
UPDATE book SET registration_date = '2022-09-06', page_count = 316, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/112324830/XL', isbn = '9791162542989' WHERE book_id = 109;
UPDATE book SET registration_date = '2023-02-15', page_count = 260, width = 149, height = 209, thumbnail_url = 'https://image.yes24.com/goods/117389523/XL', isbn = '9791130697246' WHERE book_id = 110;
UPDATE book SET registration_date = '2021-05-24', page_count = 294, width = 170, height = 225, thumbnail_url = 'https://image.yes24.com/goods/101875867/XL', isbn = '9791190877299' WHERE book_id = 111;
UPDATE book SET registration_date = '2017-07-05', page_count = 256, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/43614116/XL', isbn = '9791185541532' WHERE book_id = 112;
UPDATE book SET registration_date = '2021-03-04', page_count = 704, width = 155, height = 235, thumbnail_url = 'https://image.yes24.com/goods/97514000/XL', isbn = '9791157844852' WHERE book_id = 113;
UPDATE book SET registration_date = '2013-11-22', page_count = 388, width = 170, height = 225, thumbnail_url = 'https://image.yes24.com/goods/8017844/XL', isbn = '9788996885511' WHERE book_id = 114;
UPDATE book SET registration_date = '2019-10-21', page_count = 308, width = 146, height = 218, thumbnail_url = 'https://image.yes24.com/goods/80499154/XL', isbn = '9791188388905' WHERE book_id = 116;
UPDATE book SET registration_date = '2025-06-18', page_count = 272, width = 135, height = 200, thumbnail_url = 'https://image.yes24.com/goods/135963748/XL', isbn = '9791193937310' WHERE book_id = 117;
UPDATE book SET registration_date = '2021-07-23', page_count = 348, width = 150, height = 220, thumbnail_url = 'https://image.yes24.com/goods/102815898/XL', isbn = '9788925579870' WHERE book_id = 118;
UPDATE book SET registration_date = '2016-12-12', page_count = 128, width = 173, height = 235, thumbnail_url = 'https://image.yes24.com/goods/33531899/XL', isbn = '9791159950155' WHERE book_id = 119;
UPDATE book SET registration_date = '2022-10-12', page_count = 760, width = 188, height = 257, thumbnail_url = 'https://image.yes24.com/goods/114627204/XL', isbn = '9791163034094' WHERE book_id = 120;
UPDATE book SET registration_date = '2024-07-30', page_count = 688, width = 188, height = 257, thumbnail_url = 'https://image.yes24.com/goods/129133723/XL', isbn = '9791163036227' WHERE book_id = 121;
UPDATE book SET registration_date = '2018-03-07', page_count = 616, width = 162, height = 224, thumbnail_url = 'https://image.yes24.com/goods/58815816/XL', isbn = '9788935212057' WHERE book_id = 122;
UPDATE book SET registration_date = '2025-04-07', page_count = 748, width = 188, height = 257, thumbnail_url = 'https://image.yes24.com/goods/143912145/XL', isbn = '9791169213608' WHERE book_id = 123;
UPDATE book SET registration_date = '2015-05-20', page_count = NULL, width = 210, height = 297, thumbnail_url = 'https://image.yes24.com/goods/18291028/XL', isbn = '9791130437644' WHERE book_id = 124;
UPDATE book SET registration_date = '2018-06-15', page_count = 288, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/61491280/XL', isbn = '9791160021257' WHERE book_id = 125;
UPDATE book SET registration_date = '2020-07-23', page_count = 356, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/91165853/XL', isbn = '9791196831080' WHERE book_id = 126;
UPDATE book SET registration_date = '2023-08-02', page_count = 512, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/121144774/XL', isbn = '9791192389264' WHERE book_id = 127;
UPDATE book SET registration_date = '2019-04-24', page_count = 352, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/72230588/XL', isbn = '9791135422225' WHERE book_id = 128;
UPDATE book SET registration_date = '2016-12-16', page_count = 544, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/34427996/XL', isbn = '9788960515642' WHERE book_id = 129;
UPDATE book SET registration_date = '2023-01-30', page_count = 440, width = 188, height = 243, thumbnail_url = 'https://image.yes24.com/goods/117024911/XL', isbn = '9791140702343' WHERE book_id = 130;
UPDATE book SET registration_date = '2020-08-25', page_count = 296, width = 152, height = 215, thumbnail_url = 'https://image.yes24.com/goods/91724589/XL', isbn = '9791189352301' WHERE book_id = 131;
UPDATE book SET registration_date = '2023-09-21', page_count = 312, width = 152, height = 210, thumbnail_url = 'https://image.yes24.com/goods/122532297/XL', isbn = '9791192519883' WHERE book_id = 132;
UPDATE book SET registration_date = '2021-07-30', page_count = 464, width = 153, height = 225, thumbnail_url = 'https://image.yes24.com/goods/102951831/XL', isbn = '9788957825945' WHERE book_id = 133;
UPDATE book SET registration_date = '2025-06-02', page_count = 452, width = 153, height = 225, thumbnail_url = 'https://image.yes24.com/goods/147069298/XL', isbn = '9788957822401' WHERE book_id = 134;
UPDATE book SET registration_date = '2025-07-15', page_count = 334, width = 188, height = 257, thumbnail_url = 'https://image.yes24.com/goods/149267087/XL', isbn = '9788991378391' WHERE book_id = 135;
UPDATE book SET registration_date = '2018-06-05', page_count = 712, width = 160, height = 230, thumbnail_url = 'https://image.yes24.com/goods/61186169/XL', isbn = '9791157842636' WHERE book_id = 136;
UPDATE book SET registration_date = '2014-09-12', page_count = 820, width = 160, height = 230, thumbnail_url = 'https://image.yes24.com/goods/14156539/XL', isbn = '9788967351274' WHERE book_id = 137;
UPDATE book SET registration_date = '2007-12-29', page_count = 664, width = 188, height = 254, thumbnail_url = 'https://image.yes24.com/goods/2931642/XL', isbn = '9788937603600' WHERE book_id = 138;
UPDATE book SET registration_date = '2022-06-20', page_count = 488, width = 145, height = 212, thumbnail_url = 'https://image.yes24.com/goods/110157236/XL', isbn = '9788901260679' WHERE book_id = 141;
UPDATE book SET registration_date = '2018-03-30', page_count = 727, width = 158, height = 232, thumbnail_url = 'https://image.yes24.com/goods/59580017/XL', isbn = '9788934981213' WHERE book_id = 142;
UPDATE book SET registration_date = '2022-12-31', page_count = 420, width = 145, height = 215, thumbnail_url = 'https://image.yes24.com/goods/116585627/XL', isbn = '9788901268095' WHERE book_id = 143;
UPDATE book SET registration_date = '2023-02-25', page_count = 210, width = 138, height = 214, thumbnail_url = 'https://image.yes24.com/goods/117709746/XL', isbn = '9791166891403' WHERE book_id = 144;
UPDATE book SET registration_date = '2020-04-10', page_count = 592, width = 155, height = 225, thumbnail_url = 'https://image.yes24.com/goods/89987138/XL', isbn = '9788972917113' WHERE book_id = 146;
UPDATE book SET registration_date = '2019-04-29', page_count = 352, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/72251785/XL', isbn = '9788934995340' WHERE book_id = 147;
UPDATE book SET registration_date = '2012-10-30', page_count = 464, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/7950702/XL', isbn = '9788901150598' WHERE book_id = 148;
UPDATE book SET registration_date = '2023-01-01', page_count = 348, width = 148, height = 215, thumbnail_url = 'https://image.yes24.com/goods/116069179/XL', isbn = '9791191731415' WHERE book_id = 149;
UPDATE book SET registration_date = '2019-02-20', page_count = 416, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/69622442/XL', isbn = '9791162540633' WHERE book_id = 150;
UPDATE book SET registration_date = '2013-02-01', page_count = 300, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/8380832/XL', isbn = '9788928615810' WHERE book_id = 151;
UPDATE book SET registration_date = '2020-12-22', page_count = 464, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/96568233/XL', isbn = '9788947546720' WHERE book_id = 152;
UPDATE book SET registration_date = '2017-06-30', page_count = 320, width = 146, height = 218, thumbnail_url = 'https://image.yes24.com/goods/43209010/XL', isbn = '9791185035956' WHERE book_id = 154;
UPDATE book SET registration_date = '2023-02-10', page_count = 560, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/117120573/XL', isbn = '9791190538534' WHERE book_id = 155;
UPDATE book SET registration_date = '2025-01-02', page_count = 212, width = 135, height = 200, thumbnail_url = 'https://image.yes24.com/goods/140111551/XL', isbn = '9788974259334' WHERE book_id = 156;
UPDATE book SET registration_date = '2023-05-30', page_count = 604, width = 152, height = 225, thumbnail_url = 'https://image.yes24.com/goods/119810825/XL', isbn = '9788934965954' WHERE book_id = 158;
UPDATE book SET registration_date = '2018-02-22', page_count = 446, width = 148, height = 210, thumbnail_url = 'https://image.yes24.com/goods/58774995/XL', isbn = '9791158883591' WHERE book_id = 159;
UPDATE book SET registration_date = '2013-09-27', page_count = 388, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/11081680/XL', isbn = '9788957365793' WHERE book_id = 160;
UPDATE book SET registration_date = '2025-09-17', page_count = 352, width = 133, height = 200, thumbnail_url = 'https://image.yes24.com/goods/153497469/XL', isbn = '9791141602451' WHERE book_id = 161;
UPDATE book SET registration_date = '2025-03-28', page_count = 368, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/143911524/XL', isbn = '9788936439743' WHERE book_id = 162;
UPDATE book SET registration_date = '2016-07-04', page_count = 296, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/29288225/XL', isbn = '9788954641630' WHERE book_id = 163;
UPDATE book SET registration_date = '2023-09-06', page_count = 768, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/122090075/XL', isbn = '9788954699075' WHERE book_id = 164;
UPDATE book SET registration_date = '2021-09-09', page_count = 332, width = 138, height = 201, thumbnail_url = 'https://image.yes24.com/goods/103495056/XL', isbn = '9788954682152' WHERE book_id = 165;
UPDATE book SET registration_date = '2023-10-05', page_count = 456, width = 120, height = 210, thumbnail_url = 'https://image.yes24.com/goods/122534924/XL', isbn = '9788932923581' WHERE book_id = 166;
UPDATE book SET registration_date = '2022-09-02', page_count = 268, width = 122, height = 188, thumbnail_url = 'https://image.yes24.com/goods/112253263/XL', isbn = '9788936438838' WHERE book_id = 167;
UPDATE book SET registration_date = '2021-08-18', page_count = 392, width = 130, height = 187, thumbnail_url = 'https://image.yes24.com/goods/103026125/XL', isbn = '9791191824001' WHERE book_id = 168;
UPDATE book SET registration_date = '2022-08-03', page_count = 308, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/111085946/XL', isbn = '9788954699914' WHERE book_id = 169;
UPDATE book SET registration_date = '2021-07-27', page_count = 344, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/102687133/XL', isbn = '9788954681179' WHERE book_id = 171;
UPDATE book SET registration_date = '2023-07-14', page_count = 314, width = 138, height = 214, thumbnail_url = 'https://image.yes24.com/goods/119697570/XL', isbn = '9791198363510' WHERE book_id = 172;
UPDATE book SET registration_date = '2020-08-28', page_count = 224, width = 128, height = 198, thumbnail_url = 'https://image.yes24.com/goods/91901136/XL', isbn = '9791197021688' WHERE book_id = 173;
UPDATE book SET registration_date = '2020-07-08', page_count = 300, width = 134, height = 200, thumbnail_url = 'https://image.yes24.com/goods/91065309/XL', isbn = '9791165341909' WHERE book_id = 174;
UPDATE book SET registration_date = '2022-11-18', page_count = 276, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/115294565/XL', isbn = '9791192579283' WHERE book_id = 175;
UPDATE book SET registration_date = '2021-04-20', page_count = 268, width = 135, height = 200, thumbnail_url = 'https://image.yes24.com/goods/99308021/XL', isbn = '9791161571188' WHERE book_id = 176;
UPDATE book SET registration_date = '2019-10-25', page_count = 236, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/80742923/XL', isbn = '9788936438036' WHERE book_id = 177;
UPDATE book SET registration_date = '2016-06-27', page_count = 216, width = 145, height = 210, thumbnail_url = 'https://image.yes24.com/goods/29085183/XL', isbn = '9788936437404' WHERE book_id = 182;
UPDATE book SET registration_date = '2000-12-20', page_count = 239, width = 132, height = 225, thumbnail_url = 'https://image.yes24.com/goods/176787/XL', isbn = '9788937460449' WHERE book_id = 186;
UPDATE book SET registration_date = '2003-06-16', page_count = 444, width = 132, height = 225, thumbnail_url = 'https://image.yes24.com/goods/372300/XL', isbn = '9788937460777' WHERE book_id = 187;
UPDATE book SET registration_date = '2003-05-06', page_count = 284, width = 132, height = 225, thumbnail_url = 'https://image.yes24.com/goods/370331/XL', isbn = '9788937460753' WHERE book_id = 188;
UPDATE book SET registration_date = '2012-01-02', page_count = 193, width = 153, height = 224, thumbnail_url = 'https://image.yes24.com/goods/6157159/XL', isbn = '9788937462788' WHERE book_id = 189;
UPDATE book SET registration_date = '2011-03-25', page_count = 270, width = 133, height = 225, thumbnail_url = 'https://image.yes24.com/goods/4827613/XL', isbn = '9788937443848' WHERE book_id = 190;
UPDATE book SET registration_date = '2018-06-20', page_count = 520, width = 125, height = 190, thumbnail_url = 'https://image.yes24.com/goods/61933303/XL', isbn = '9788937437564' WHERE book_id = 191;
UPDATE book SET registration_date = '2000-01-31', page_count = 297, width = 132, height = 225, thumbnail_url = 'https://image.yes24.com/goods/96378/XL', isbn = '9788937460340' WHERE book_id = 192;
UPDATE book SET registration_date = '2023-01-17', page_count = 320, width = 133, height = 225, thumbnail_url = 'https://image.yes24.com/goods/204300/XL', isbn = '9788937460470' WHERE book_id = 193;
UPDATE book SET registration_date = '2004-05-15', page_count = 191, width = 132, height = 225, thumbnail_url = 'https://image.yes24.com/goods/1387488/XL', isbn = '9788937461033' WHERE book_id = 194;
UPDATE book SET registration_date = '2025-09-30', page_count = 244, width = 128, height = 188, thumbnail_url = 'https://image.yes24.com/goods/154932317/XL', isbn = '9791175240537' WHERE book_id = 195;

-- ==========================================================
-- 판매량 데이터 (월간 베스트셀러용)
-- ==========================================================

-- 기존 데이터에 대한 초기값 설정
UPDATE book SET sales_count = 0 WHERE sales_count IS NULL;
UPDATE book SET monthly_sales = 0 WHERE monthly_sales IS NULL;

-- 월간 베스트셀러 샘플 데이터 설정 (TOP 20)
UPDATE book SET monthly_sales = 1250, sales_count = 8500, last_sales_update = NOW() WHERE book_id = 1;   -- 지금처럼 영원히 함께해
UPDATE book SET monthly_sales = 980, sales_count = 5200, last_sales_update = NOW() WHERE book_id = 2;    -- 당신이 글을 쓰면 좋겠습니다
UPDATE book SET monthly_sales = 875, sales_count = 4100, last_sales_update = NOW() WHERE book_id = 6;    -- 나는 메트로폴리탄 미술관의 경비원입니다
UPDATE book SET monthly_sales = 820, sales_count = 6800, last_sales_update = NOW() WHERE book_id = 13;   -- 몰입
UPDATE book SET monthly_sales = 750, sales_count = 3900, last_sales_update = NOW() WHERE book_id = 30;   -- 매일매일 좋은 날
UPDATE book SET monthly_sales = 680, sales_count = 7200, last_sales_update = NOW() WHERE book_id = 20;   -- 지적 대화를 위한 넓고 얕은 지식 0
UPDATE book SET monthly_sales = 625, sales_count = 2850, last_sales_update = NOW() WHERE book_id = 32;   -- 세이노의 가르침
UPDATE book SET monthly_sales = 590, sales_count = 4500, last_sales_update = NOW() WHERE book_id = 52;   -- 내가 틀릴 수도 있습니다
UPDATE book SET monthly_sales = 540, sales_count = 3200, last_sales_update = NOW() WHERE book_id = 28;   -- 당신도 느리게 나이 들 수 있습니다
UPDATE book SET monthly_sales = 485, sales_count = 2100, last_sales_update = NOW() WHERE book_id = 61;   -- 골든아워 1
UPDATE book SET monthly_sales = 460, sales_count = 3800, last_sales_update = NOW() WHERE book_id = 40;   -- 역행자
UPDATE book SET monthly_sales = 440, sales_count = 5100, last_sales_update = NOW() WHERE book_id = 101;  -- 트렌드 코리아 2026
UPDATE book SET monthly_sales = 420, sales_count = 2900, last_sales_update = NOW() WHERE book_id = 39;   -- 아주 작은 습관의 힘
UPDATE book SET monthly_sales = 395, sales_count = 4200, last_sales_update = NOW() WHERE book_id = 85;   -- 사피엔스
UPDATE book SET monthly_sales = 370, sales_count = 3100, last_sales_update = NOW() WHERE book_id = 19;   -- 돈의 속성
UPDATE book SET monthly_sales = 350, sales_count = 2700, last_sales_update = NOW() WHERE book_id = 41;   -- 라틴어 수업
UPDATE book SET monthly_sales = 335, sales_count = 3600, last_sales_update = NOW() WHERE book_id = 148;  -- 습관의 힘
UPDATE book SET monthly_sales = 320, sales_count = 2500, last_sales_update = NOW() WHERE book_id = 56;   -- 트렌드 코리아 2023
UPDATE book SET monthly_sales = 305, sales_count = 3300, last_sales_update = NOW() WHERE book_id = 82;   -- 미움받을 용기
UPDATE book SET monthly_sales = 290, sales_count = 2400, last_sales_update = NOW() WHERE book_id = 174;  -- 달러구트 꿈 백화점

-- 경제/경영 카테고리 도서 추가 (category_id: 12, 13, 14, 15)
INSERT IGNORE INTO book (book_id, title, publisher, price, isbn, description, category_id) VALUES
(201, '부의 추월차선', '토네이도', 17820, '9791158511686', '부자 아빠 가난한 아빠의 저자 로버트 기요사키가 추천한 부의 공식', 12),
(202, '마케팅 4.0', '비즈니스북스', 19800, '9791162540657', '디지털 시대의 마케팅 전략과 고객 경험 혁신', 13),
(203, '린 스타트업', '알에이치코리아(RHK)', 18000, '9788925567796', '창업과 혁신을 위한 린 방법론', 14),
(204, '성공하는 사람들의 7가지 습관', '김영사', 19800, '9788934991206', '스티븐 코비의 시간 관리와 성공 철학', 15),
(205, '블루오션 전략', '김영사', 19800, '9788934991213', '경쟁 없는 시장을 창조하는 혁신적 사고법', 14);

-- 역사 카테고리 도서 추가 (category_id: 20, 21, 22, 23)
INSERT IGNORE INTO book (book_id, title, publisher, price, isbn, description, category_id) VALUES
(206, '사피엔스', '김영사', 19800, '9788934991220', '유발 하라리가 들려주는 인류의 역사', 20),
(207, '조선왕조실록', '세계사', 22500, '9788933870641', '조선 500년의 역사를 한눈에 보는 완전판', 21),
(208, '역사란 무엇인가', '을유문화사', 16200, '9788932474438', 'E.H. 카의 역사학 입문서', 22),
(209, '전쟁과 평화', '문학동네', 22500, '9788954655984', '톨스토이의 대작, 나폴레옹 전쟁을 배경으로 한 소설', 23),
(210, '한국사 편지', '푸른역사', 18000, '9791158881234', '어린이와 청소년을 위한 재미있는 한국사', 21);

-- 인문 카테고리 도서 추가 (category_id: 24, 25, 26, 27)
INSERT IGNORE INTO book (book_id, title, publisher, price, isbn, description, category_id) VALUES
(211, '심리학의 이해', '시그마프레스', 19800, '9788968661234', '현대 심리학의 주요 이론과 실제', 24),
(212, '철학의 역사', '이학사', 22500, '9788961471234', '고대부터 현대까지 철학사 개론', 25),
(213, '신화의 힘', '웅진지식하우스', 18000, '9791169851234', '조지프 캠벨의 신화와 영웅의 여행', 26),
(214, '인류학의 눈', '한길사', 16200, '9788935651234', '문화와 사회를 이해하는 인류학적 시각', 27),
(215, '마음의 평화', '불광출판사', 14400, '9788958201234', '불교 철학을 통한 마음의 평정', 25);

-- 자기계발 카테고리 도서 추가 (category_id: 28, 29, 30, 31)
INSERT IGNORE INTO book (book_id, title, publisher, price, isbn, description, category_id) VALUES
(216, '원씽', '비즈니스북스', 16200, '9791162540664', '한 가지에 집중하는 힘', 28),
(217, '어떻게 원하는 것을 얻는가', '알에이치코리아(RHK)', 18000, '9788925567802', '인간관계와 소통의 기술', 29),
(218, '성장 마인드셋', '김영사', 16200, '9788934991237', '고정 마인드셋에서 성장 마인드셋으로', 30),
(219, '커리어 스위치', '비즈니스북스', 19800, '9791162540671', '중년의 커리어 전환과 새로운 도전', 31),
(220, '습관의 재발견', '알에이치코리아(RHK)', 16200, '9788925567819', '좋은 습관을 만드는 과학적 방법', 28);

-- 새로 추가된 도서들에 판매량 설정
UPDATE book SET monthly_sales = FLOOR(100 + RAND() * 200), sales_count = FLOOR(500 + RAND() * 1500), last_sales_update = NOW() 
WHERE book_id BETWEEN 201 AND 220;

-- 나머지 책들에도 랜덤한 판매량 설정
UPDATE book SET monthly_sales = FLOOR(50 + RAND() * 250), sales_count = FLOOR(200 + RAND() * 2000), last_sales_update = NOW() 
WHERE book_id NOT IN (1, 2, 6, 13, 30, 20, 32, 52, 28, 61, 40, 101, 39, 85, 19, 41, 148, 56, 82, 174, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220);

