#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere(vec3 ro, vec3 rd){
	float r=0.3;
	float b=2.0*dot(ro, rd);
	float c=dot(ro,ro) - r*r;
	float h=b*b-4.0*c;
	if(h<0.0)return -1.0;
	return (-b-sqrt(h))/2.0;
}

float intersect(vec3 ro, vec3 rd){
	float t=iSphere(ro, rd);
	return t;
}

void main( void ) {

	vec2 res=vec2(1.0,resolution.x/resolution.y);
	vec2 uv = ( gl_FragCoord.xy / resolution.xy )/res;
	vec3 col =vec3(0.0);
	
	//origine
	vec3 ro=vec3(0.0,1.0,2.0);
	
	//direction
	vec3 rd=normalize(vec3(-1.0+2.0*uv,-1.0));
	
	float id=intersect(ro,rd);
	if(id>0.0){
		col=vec3(1.0);
	}

	gl_FragColor = vec4(col,0.0);

}