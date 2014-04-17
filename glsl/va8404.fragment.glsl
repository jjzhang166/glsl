#ifdef GL_ES
precision mediump float;
#endif

//acs

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circleSdf(vec2 pos){		
	return length(vec2(pos));
}

float fl(vec2 pos){
	
	return smoothstep(0.0, 1.0, (256.0/resolution.y + mod(pos.y-(time*0.01), .01)));

}

void main( void ) {

	vec2 aspect = vec2(1.6, 0.9);

	vec2 pos2 = mouse.xy * aspect - gl_FragCoord.xy / resolution.xy * aspect;
	
	float s1 = circleSdf(pos2); 
	float s2 = circleSdf(vec2(sin(time*.1),cos(time*.14)) * pos2 - s1); 
	float s3 = circleSdf(vec2(cos(time*.4), sin(time*.24)) * pos2 - s2); 
	float s4 = circleSdf(vec2(cos(time*.1), sin(time*.42)) * pos2 - s3); ; 
	
	float s = s1 * s2 * s3 * s4;
	
	vec4 color = normalize(vec4(s1, s2, s3, s4)) - s4;
	
	
	float field; 
	field =  fl(s * color.xy);
	field *= fl(s * color.yx);
	
	field *= fl(s * color.xz);
	field *= fl(s * color.zx);
	
	field *= fl(s * color.yz);
	field *= fl(s * color.zy);

	color /= field;
	
	
	float c1 = smoothstep(0.3, .43, s1);
	float c2 = smoothstep(0.23, .43, s2);
	float c3 = smoothstep(0.3, .43, s3);
	
	color = color / (c1 * c2 * c3);
 
	
	gl_FragColor =  pow(normalize(sin(field+color)), vec4(field-color))*20.;
		
}