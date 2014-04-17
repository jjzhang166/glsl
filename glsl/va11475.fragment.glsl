#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float numLines;


bool near(float i, float t, float e){
	return i < t+e && i > t-e;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float randRange( float start, float end){
	float val;//= ( shouldRound )? floor( start + (random() * (end - start) )) : ;
	
	return ( start + (rand( vec2(25.0, 20.0)  ) * (end - start) ));
	//return start * rand( vec2(2.0, 3.0));
}

void main(void){
	vec2 position = ( gl_FragCoord.xy );
	
	float line_thick = 1.0;
	float half_line_thick = 0.5;
	float amp = (resolution.y * 0.3) * sin(time);//0.15;
	float numItem = 70.0;
	float numLiner = 10.0;
	
	
	float rVal = 0.1;
	float gVal = 0.1;
	float bVal = 0.1;
	float friction = 0.23;
	
	for(float i = 0.0; i < 20.0; i++){
		
		rVal += sin( mouse.x * friction);
		bVal += cos( time * friction);
		gVal += tan( time * friction );
		
		float v;
		if( mod(i, 2.0) == 0.0 ){
		   v = (( sin( position.x *-0.0065 + time*  randRange(2.0, 5.0) ) * 0.5 + cos(position.x * -0.005 + time * randRange(1.0, 8.0) ) * 0.5 ) * amp*0.8);
		}else{
		   v = (( cos( position.x *-0.0065 + time*  randRange(2.0, 5.0) ) * 0.5 + cos(position.x * -0.005 + time * randRange(1.0, 8.0) ) * 0.5 ) * amp*0.8);
		}
		
		
		if(near(position.y, (v + resolution.y*0.35 + i*20.0 ),3.75)){
			gl_FragColor = vec4(rVal, gVal, bVal,1.0 );		
		}
	}
}