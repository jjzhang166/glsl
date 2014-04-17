#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D b;

// Psychedelic julia sets by Kabuto 
// Now properly psychadelic by Psonice

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy * 2. - 2.)*vec2(1.,.5) + vec2(sin(time*.35), cos(time*.55)) * .25;
	vec2 src = 1.-abs(fract((vec2(position.x*position.x-position.y*position.y+sin(time*.3)*.25-1.,2.*position.x*position.y+cos(time*.3)*.25)*vec2(.25,.5)+.5)*.5)*2.-1.);
	src *= resolution.xy;
	vec2 srcf = floor(src);
	vec2 srcn = fract(src);
	
	srcn *= 0.25;
	vec4 color = vec4(0.0);
	float m = 1.;
	for(int i=0; i<4; i++){
		//color = mix(color, texture2D(b, (srcf+vec2(0,0))/resolution.xy)*(1.-srcn.x)*(1.-srcn.y)
		  // + texture2D(b, (srcf+vec2(1,0))/resolution.xy)*srcn.x*(1.-srcn.y)
		  // + texture2D(b, (srcf+vec2(0,1))/resolution.xy)*(1.-srcn.x)*srcn.y
		  // + texture2D(b, (srcf+vec2(1,1))/resolution.xy)*srcn.x*srcn.y,
		//	    m);
		srcn *= 2.;
		m *= .5;
	}
	//color /= 4.;
	
	vec2 p = position*.5;
	float atan = atan(p.y,p.x);
	float dist = length(p);
	
	float dist2 = dist - (cos(atan*9.+time*.7)*.5*cos(time)+cos(atan*15.+time*.2)*.5*sin(time)+1.);
	
	float mask = max(1.-abs(dist2)*(sin(time*.2)*40.+60.),0.);
	
	color = color * (1.-mask) + (cos(time+dist2*vec4(sin(time*.19) * 192.,sin(time*.17)*130.,sin(time*.13)*100.,0.))*2.0+0.001)*mask;
	
	gl_FragColor = vec4( color );

}