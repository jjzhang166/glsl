#ifdef GL_ES
precision mediump float;
#endif

//just work in progress, nothing to see here...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float circleSdf(vec2 pos){		
	return length(vec2(pos));
}

float fl(vec2 pos){
	float l1 = smoothstep(0.1, 0.9, (256.0/resolution.y - mod(pos.y-(time*0.03), 0.4)));
	return l1 - smoothstep(0.4, 0.6, (256.0/resolution.y + mod(pos.y-(time*.09), .09)));

}

void main( void ) {

	vec2 aspect = vec2(1.6, 0.9);
	//float depth = mouse.x * 100.;
	//depth /= resolution.xy;
	
	vec2 pos2 = 0.5 * aspect - gl_FragCoord.xy / resolution.xy * aspect;
	//vec3 pos3 = vec3(pos2, depth);

	
	float s1 = circleSdf(pos2); 
	float s2 = circleSdf(pos2 + mouse.xy - 0.5); 
	float s3 = circleSdf(pos2 + mouse.yx - 0.5); 
	float s4 = s1; 
	
	float s = s1 * s2 * s3 * s4;
	s = s / s;
	
	vec4 color = s-normalize(vec4(s1, s2, s3, s4));
	
	
	float field; 
	field =  fl(s * color.xy);
	field *= fl(s * color.yx);
	
	field *= fl(s * color.xz);
	field *= fl(s * color.zx);
	
	field *= fl(s * color.yz);
	field *= fl(s * color.zy);
	
	color -= field;
	
	
	float c1 = smoothstep(0.04, .043, s1);
	float c2 = smoothstep(0.04, .043, s2);
	float c3 = smoothstep(0.04, .043, s3);
	
	color += 1.0 - c1*c2*c3;

	
	vec4 buffer = texture2D(backbuffer, s*field+color.xy + field);
	color *= pow(color, buffer);
	
	gl_FragColor = color;
		
}