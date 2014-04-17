#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float ev(vec3 p) {
	//yure
	p.x += -cos(p.y+time*2.0) * 0.3;
	p.y +=  sin(p.z+time*4.0) * 0.3;
	p.z += -cos(p.y+time*3.0) * 0.3;
	
	float jj = sin(p.x * 26.0) + sin(p.y * 17.0) +sin(p.z * 22.8);      //hunya
	float a = length(abs(mod(p, 2.0)) - 1.0) - 0.1;                     //ball
	float b = 5.0 - dot(abs(p), vec3(0, 1.0, 0))            + jj * 0.01;//plane
	float h = 5.0 - dot(p, vec3(0, 1.0, 0).yzx);            + jj * 0.01;//plane
	float c = length(abs(mod(p.xz,  16.0)) - 8.0) - 6.0     + jj * 0.01;//npoll1
	float r = length(abs(mod(p.xz + 1.5, 8.0)) - 4.0) - 3.0 + jj * 0.01;//npoll2	
	float d = length(abs(mod(p.xz,  4.0)) - 2.0) - abs(0.1+sin(time) * 0.3)      + jj * 0.01;//poll2
	
	//mix
	float k = min(h, b);
	
	//not
	k = max(-c, k);
	k = max(-r, k);
	
	//mix
	k = min(a, k);
	k = min(d, k);
	return k;
}

void main( void ) {
	vec2 uv = -1.0 + 2.0*(gl_FragCoord.xy/resolution.xy);
	vec3 e = vec3(sin(time * 0.3), 0, time * 3.0);
	vec3 D = normalize(vec3(uv.x * 1.25, uv.y, 1.0));

	//rotate
	float rot = time * 0.1;
	float sn  = sin(rot);
	float cn  = cos(rot);
	D.xy = vec2(cn * D.x - sn * D.y, sn * D.x + cn * D.y);
	D = D.xzy;
	D.xy = vec2(cn * D.x - sn * D.y, sn * D.x + cn * D.y);

	//distance field
	vec3 p = e;
	float k = 0.0;
	for(int i = 0 ; i < 76; i++) {
		k = ev(p);
		p += D * k * 0.95;
	}
	
	//fog
	float fog = length(p - e) * 0.025;
	
	//calc fake normal
	vec2  de  = vec2(0.01, 0.0);
	vec3   N  = normalize(vec3(
		k - ev(p - de.xyy), 
		k - ev(p - de.yxy), 
		k - ev(p - de.yyx)));
	
	//color
	vec3 c = vec3(D * 0.2 + max(pow(dot(N, -D), 12.0), 0.0) + fog);
	gl_FragColor = vec4(c, 1);
}