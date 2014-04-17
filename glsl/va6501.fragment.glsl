#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float showText2(vec2 p, float r0, float r1, float r2, float r3, float r4, float ofs, float mx, float my) {
	if(p.y < 0. || p.y > 5.) return 0.; // Bit count Y
	if(p.x < 0. || p.x > 24.) return 0.; // Bit count X
		
	float v = r0;
	v = mix(v, r1, step(p.y, 4.));
	v = mix(v, r2, step(p.y, 3.));
	v = mix(v, r3, step(p.y, 2.));
	v = mix(v, r4, step(p.y, 1.));
	
	float x = floor(p.x);
	float y = floor(p.y);

	
	
	return floor(mod((v+ofs)/pow(2.,x), 2.0))*mod(x+mx,2.)*mod(y+my,2.) * (0.8 + 0.3 * cos(y + x + time));
}
float showText(vec2 p, float r0, float r1, float r2, float r3, float r4, float ofs, float t) {
	float s = sin(t)*.2;
	float c = cos(t)*.2;
	return (
		showText2(p+vec2(c,s),r0,r1,r2,r3,r4,ofs,0.,0.)+
		showText2(p+vec2(-s,c),r0,r1,r2,r3,r4,ofs,1.,0.)+
		showText2(p+vec2(s,-c),r0,r1,r2,r3,r4,ofs,0.,1.)+
		showText2(p+vec2(-c,-s),r0,r1,r2,r3,r4,ofs,1.,1.)
	)*.5;
}

vec3 rotateY(float a, vec3 p)
{
	return vec3(cos(a) * p.x + sin(a) * p.z, p.y, cos(a) * p.z - sin(a) * p.x);
	}


vec3 rotateX(float a, vec3 p)
{
	return vec3(p.x, cos(a) * p.y + sin(a) * p.z, cos(a) * p.z - sin(a) * p.y);
	
	}

vec3 transform(vec3 p, float t)
{
	return rotateX(cos(t * 0.3) * 0.5, rotateY(sin(t) * 0.5, p));
}

vec4 scene(float t)
{
	vec3 ro = transform(vec3(0.0, 0.0, 1.0), t);
	vec3 rd = transform(vec3(gl_FragCoord.xy / resolution.xy * 2.0 - vec2(1.0), -1.0), t);
	
	rd.xy = normalize(rd.xy) * pow(length(rd.xy), 0.8);
	
	float ti = -ro.z / rd.z;
	
	//vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 position = (ro + rd * ti).xy;
	
	position -= vec2(-1.0, -2.5);
	position *= vec2(0.5, 0.3);

	
	vec2 fc = gl_FragCoord.xy/resolution.xy*vec2(960,500);
	vec3 test = vec3(sin(fc.x*.01),sin(fc.y*.01),cos(-time+dot(fc.xy,vec2(.008,.006))));
	for (int i = 0; i < 4; i++) {
		test = (test+test.yzx)*test.z*.5+(vec3(fc.xy,0)*.004-.8);
	}
	
	
	float color = dot(test,vec3(1.)) + mod(gl_FragCoord.y,2.)*.4-.2;


	vec4 res = vec4( vec3( color, color * 0.5, sin( color +3.1 ) * 0.75 ), 1.0 );
	
	vec2 pos = vec2(-position.x*35.,position.y*25.);
	res += showText(pos + vec2(12.,-18.),  516., 516.,  951.,  677.,  935., 0., t);
	res += showText(pos + vec2(30.,-18.),  59904., 16896.,  19319.,  19029.,  19325., 0., t);
	
	
	res.rgb = mix(res.rgb, vec3(0.0), step(t, 0.0));	
	return res;
}

void main( void ) {

	gl_FragColor = vec4(0.0);
	
	
	
	for(int i = 0; i < 10; i += 1)
	{
		gl_FragColor += scene(time + float(i) * 0.02);
		}
	
	gl_FragColor *= 0.1;
}