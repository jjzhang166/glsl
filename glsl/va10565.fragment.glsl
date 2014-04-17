#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform float time;
uniform vec2 pd;
uniform vec2 mouse;

vec2 uv;

float circle(vec2 uv){
	return length(uv);
}

float bloom(vec2 pos){
	float g=1.0-length(uv+vec2(pos));
	return g;
}

//左下(1.0,1.0)
//右上(-1.0,-1.0)

void main(void){
	float dimar = gl_FragCoord.x / resolution.x;
	float dimag = gl_FragCoord.y / resolution.y;
	float dimab = mouse.x;
	uv = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	vec2 uv2 = (gl_FragCoord.xy / resolution.xy);
	float r;
	float j;
	float h=pd.x;
	float time=time;
	float mx=mouse.x*2.0-1.0;
 	float my=mouse.y*2.0-1.0;
	
	for(float i=0.0;i<100.0;i++){
	r += circle(uv+vec2(
		fract(i/10.0)*2.0-0.9,
		fract(floor(i/10.0)/10.0)*2.0-0.9
	));
	}

	
	j=bloom(uv+vec2(mx*-2.0,my*-2.0));
	r = r+j;
	
	
	gl_FragColor=vec4(r,r,r,0.5);
	gl_FragColor=vec4(dimar+r,dimag+r,dimab+r,1.0);
	
}
