#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//botched lit sphere

vec3 sphere(vec2 pos, float r, vec3 light, vec2 uv){
	vec3 ret;
	if(distance(uv,pos)<r){
		vec2 xy=(pos-uv)/r;
		float z=sqrt(1.-xy.x*xy.x-xy.y*xy.y);
		z+=1.;
		z*=0.5;
		//xy+=0.5;
		xy+=1.;
		xy*=0.5;
		vec3 n=(vec3((xy),z));
		//ret.rg=xy;
		//ret=n;
		//amb+diff+spec
		ret=vec3(0.1,0.1,0.1);
		ret+=vec3(0.1,0.75,0.2)*max(dot(n,light),0.);
		
	}
	else{
		//ret.xy=(light);
	}
	
	return ret;
}



void main( void ) {

	vec2 pos= ( gl_FragCoord.xy / resolution.xy );
	pos.x*=resolution.x/resolution.y;
	vec2 m=mouse;
	m.x*=resolution.x/resolution.y;
	vec3 color;
	//color=vec3(pos,0.);
	color+=sphere(vec2(0.5,0.5),0.25,normalize(vec3(cos(time),sin(time),0.1)),pos);
	
	gl_FragColor = vec4(color,1.);

}