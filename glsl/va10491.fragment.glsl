#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 4378.5453);
}

float noise(vec2 n) {
	vec2 d = vec2(0.0,1.);
	vec2 b = floor(n);
	vec2 f = smoothstep(vec2(0.0), vec2(1.), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

void main( void ) {

	vec2 uv = (  gl_FragCoord.xy / resolution.xy );
	vec2 pos = uv;
	pos.x*=512.;
	pos.y*=128.;
	vec2 m=mouse-0.5;

	vec3 color;
	
	float r;
	float g;
	float b;

	
	
	vec2 w;
	w.x = (1.-pos.y*sin(time+pos.y*.02))*cos(time*.7)* 0.02;
	
	w.y = 1.+sin(.015*pos.x+time*3.);
	w.y *= .5*-cos(0.01*pos.x+time*.3-w.y) * pos.y *.05;
	
	vec2 h;
	h.x = .3;
	h.y = .9;
	
	h+=.9*-w;
	
	pos+=w*3.;

	for(float i=0.;i<1.;i+=0.05){
		r+= noise(pos+h*i*64.);
		r-= .03 * pos.y;
		
		g+= noise(pos+h*i*32.-r*.4);
		g-= .05*step(w.y, g);
		g-= .035 * pos.y;
		
	}

	g*= 0.05;
	
	color = clamp(vec3(g*.4, g, (.04*g)), 0., 1.);
	color += vec3(.7 * uv.y-.15+uv.x*.13, .5 * uv.y-.05, .9*uv.y-uv.x*.14)+uv.y*.14;
	
	gl_FragColor = vec4( color, 0.);
	
	//fun on breaktime, could be refactored all over
	//sphinx
}