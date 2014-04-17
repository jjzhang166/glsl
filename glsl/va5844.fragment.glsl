//THIS SHADER IS TAKEN FROM THE EXAMPLE GIVEN IN THIS THESIS http://aka-san.halcy.de/distance_fields_prefinal.pdf
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float scene(vec3 pos){
	float ball1 = 1.0/length(pos - vec3(abs(-1.5), 0.0, 4.0));
	float ball2 = 1.0/length(pos - vec3(1.0, 1.5, 5.0));
	float ball3 = 1.0/length(pos - vec3(3.0, -2.5, 5.0));
	return 1.0/(ball1 + ball2 + ball3) -1.0;
}

void main( void ) {
	vec3 ray=vec3((gl_FragCoord.xy - vec2(300.0))/300.0,1.0);
	ray =normalize(ray);
	float dist=1000.0;
	vec3 pos=vec3(0.0);
	int c;
	
	for(int ci = 0; ci <= 500; ci++){
		if(dist < .01){
			break;
		}
		dist=scene(pos);
		pos+=dist * ray;
		c = ci;
	}
	
	vec3 d=vec3(0.01,0.0,0.0);
	vec3 n=normalize(vec3(
		scene(pos+d.xyy)-scene(pos-d.xyy),
		scene(pos+d.yxy)-scene(pos-d.yxy),
		scene(pos+d.yxx)-scene(pos-d.yxx)
	));
	
	if(c<500){
		vec3 light=vec3(4.0, -2.0, 0.0);
		vec3 tolight=normalize(light-pos);
		float diff=max(0.0,dot(n,tolight));
		vec3 reflected=normalize(reflect(tolight,n));
		float spec=max(0.0,pow(dot(reflected,normalize(pos)),10.0));
		vec4 colour=vec4(0.0 , .5 , 1.0 , 1.0);
		gl_FragColor=vec4(diff+0.2)*colour+vec4(spec*0.3);
	}else{
		gl_FragColor=vec4(0);
	}
	return;
}