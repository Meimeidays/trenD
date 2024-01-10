package com.td.TrenD.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.td.TrenD.model.CategoryVO;
import com.td.TrenD.model.StatisticsVO;
import com.td.TrenD.model.TrendVO;
import com.td.TrenD.service.AgeService;
import com.td.TrenD.service.GenderService;
import com.td.TrenD.service.LocationService;
import com.td.TrenD.service.CategoryService;
import com.td.TrenD.service.StatisticsService;
import com.td.TrenD.service.TrendService;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import javax.persistence.EntityManager;

import org.json.JSONException;
import org.json.JSONObject;

@Controller
public class StatisticsController {
	
	@Autowired
	StatisticsService service;
	@Autowired
	TrendService trendService;
	@Autowired
	CategoryService categoryService;
	@Autowired
	AgeService ageService;
	@Autowired
	GenderService genderService;
	@Autowired
	LocationService locationService;
	
	//'통계'를 클릭했을 때 이동할 페이지
	@RequestMapping("/Statistics")
	public String Statics(Model model) {
		
	//우선 데이터를 가져와야 함. 클릭수가 저장된 테이블에서 키워드와 클릭수를 연관지어 가져옴
	//클릭수를 세는 법 : 특정 유저가 키워드에 최초 접속 시 새로운 게시글이 하나 만들어짐. 통계 테이블엔 유저 아이디 + 게시글 번호를 가진 행이 하나 추가됨
	//이후 다른 유저들이 해당 키워드에 접속하게 되면 해당 게시글 번호 + 유저 아이디가 입력된 행이 하나 추가되는 방식	
		
	//내게 필요한 정보는?
	//1.카테고리 이름. 2.해당 카테고리를 얼마나 클릭했는지를 알아내야 함.
	//키워드에 접속 시 하나의 게시글이 만들어짐. staNo,userId,trNo 세 가지 정보를 가진 통계 테이블. staNo는 단순 관리용이니 무시. 유의미한 값은 userId와 trNo 둘 뿐
	//최초 접속 시 userId와 trNo가 기록. 모든 유저가 최초 접속시에는 해당 정보가 계속해서 생성됨. trNo는 그대로지만 userId값이 계속 변화하는 것. trNo는 해당 키워드에 가장 먼저 생겨난 글을 의미
		
	//ex)사이트 개설 이후 first 유저가 '날씨' 카테고리로 접속. 
	//category_code 테이블앤 cateCd:1,cateNm:'날씨',cateDelYn:'N',인덱스 라는 정보를 가진 행이 존재
	//trend_tbl에 trNo:1,userId:first,cateCd:1,trSubject:첫글,trContent:내용,trReadcount:0,trDate:생성일,trUpdate:null,trDelYn:n인 행이 생성됨
	//statistics테이블엔 staNo:1,userId:first,trNo:1 이라는 행이 생성됨
	//이후 두 번째 유저 second가 날씨 카테고리에 접속
	//다른 모든 테이블은 그대로지만, statistics테이블엔 staNo:2,userId:second,trNo:1 이라는 행이 새로 생성됨
	//statistics테이블엔 trNo가 1인 행이 두 개 존재. 이것이 날씨 키워드의 통계가 됨
		
	//실제 코드 작동 방식은 다르다. trNo는 애초에 게시글 번호. 게시글을 클릭할 때마다 statistcs 테이블에 userId와 trNo가 들어간 컬럼이 생성됨
	//애초에 처음 단계에서 조인을 해야 할 듯. statistcs 테이블과 카테고리 이름이 있는 테이블까지 조인한 형태의 테이블 안에서 count(*)함수를 사용해야 함	
	//반복문에 필요한 것. 1.모든 카테고리 이름 2.조인한 상태의 테이블 3.카테고리 이름을 통해 조인 테이블의 내부에서 해당 카테고리가 클릭된 횟수를 찾아냄
		
		
		
		
		
	//1.컨트롤러에선 존재하는 모든 카테고리 이름을 검색
	//select * from category_code로 찾아낸 값들을 List<CategoryVO>에 저장. 해당 쿼리문은 jparepositiry가 기본 제공
	//List<Integer> click = service.getTrNo();
	List<CategoryVO> category = categoryService.get();
	
	JSONObject jo = new JSONObject();  //json라이브러리 사용을 위한 객체 선언.
	List<JSONObject> list = new ArrayList<JSONObject>();
		
	//2.CategoryVO의 cateNm 값을 이용해 CategoryVO의 cateCd값을 알아냄
	//3.cateCd 값들의 갯수를 count(*)함수를 이용해 파악. 이때 statistics s left join trend_tbl t 조인 테이블에서 갯수를 알아내야 함
	//4.이 둘을 짝지어 json 형태로 변환 후 뷰페이지로 전송
	//해당 작업들은 for문의 같은 칸에서 이루어져야 함. 
	int index = 0;
	for(CategoryVO c : category) {
		//c는 CategoryVO. 같은 행의 cateCd값을 알아냄
		if(!c.getCateNm().equals("트렌드")) {
		String categoryOpt = c.getCateCd();  //cateCd값
		//3.cateCd 값들의 갯수를 count(*)함수를 이용해 파악. 이때 statistics s left join trend_tbl t 조인 테이블에서 갯수를 알아내야 함
		int categoryCount = service.count(categoryOpt); 
		//categoryCount에는 두 개의 테이블을 아우터 조인하고, 그 중 하나의 컬럼만을 전부 출력한 결과값이 포함되어 있음. 이것의 갯수를 세야 함
		//String cate = trendOpt.get().getCategoryVO().getCateCd();
		//cateCd값을 통해 category_code 테이블의 cateNm값을 알아냄
		//Optional<CategoryVO> categoryOpt = categoryService.getCategory(cate);
		//String category = categoryOpt.get().getCateNm();
		
		//int count = service.count(c);
		//trNo 값들의 갯수를 count(*)함수를 이용해 파악
		
		//그 후 json 형태로 가공. x:키워드,value:클릭수의 형태
		jo.put("x", category.get(index).getCateNm());  //x : category 형태의 데이터가 하나 저장됨, 이 작업을 list가 빌 때까지 반복
		jo.put("value", categoryCount);  //value : count 형태의 데이터가 하나 저장됨, 이 작업을 list가 빌 때까지 반복
		list.add(jo);
		jo= new JSONObject();  //JSONObject 객체를 초기화. 
							   //초기화를 따로 하지 않으면 map 객체 내부의 값까지 변경되어 모든 원소가 가장 마지막에 입력되는 값으로 결정됨
		index++;
		}
	}
	
	
	
	
	System.out.println(list);
	model.addAttribute("json", list);
	//json 데이터를 뷰 페이지로 전송, 뷰 페이지에선 워드클라우드 라이브러리가 이 자료들을 받아 출력	
	return "Statistics";
	}
		
}
