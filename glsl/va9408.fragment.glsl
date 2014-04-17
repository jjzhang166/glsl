// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fun(float numLegs, float time) {
	vec2 p = -1.0+2.0*gl_FragCoord.xy/resolution.xy+vec2(sin(time*0.07*numLegs)/2.0,cos(time*0.17*numLegs)/2.0);
	float dist		= length(p);
	
	float w = -sin(sqrt(dot(p,p)*(sin(cos(time*5.0))*3.0+15.0))+time*3.0); 	//part 2 -- bend
	float x = cos(numLegs*atan(p.y,p.x) + 5.0*w);	//part 1 -- legs and fade
	
	vec3 brightColor = vec3(0.5,-0.5,-0.7)*5.0;
	float brightColorFade = min( max( 0.7 - dist * 0.7 , 0.1 ), 0.5 );
	
	vec3 col = vec3(brightColor*x*(sin(cos(time*2.0))*0.3+0.8)*brightColorFade);
	col.r *= mod(gl_FragCoord.y, 2.0)*(sin(time)*0.2+0.4);
	
	return col;
}

void main(void) {
	float delta = time*0.3;

	vec3 c1 = vec3(dot(fun(2.0, delta), vec3(0.8, 0.5, 0.2)))*vec3(0.7,0.5,0.9);
	vec3 c2 = fun(5.0, -delta);
	vec3 c3 = fun(13.0, delta);
	
	float mr1 = sin(time+sin(time*0.37)*0.42)*0.5+0.5;
	float mr2 = sin(time*0.5+cos(time*0.11))*0.5+0.5;

	vec3 m = mix(c1, c2, mr1);
	m = mix(m, c3, mr2);
	gl_FragColor = vec4(m, 1.0);

}