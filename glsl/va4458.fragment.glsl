#ifdef GL_ES
precision mediump float;
#endif

#define R(p,a) p=vec2(p.x*cos(a)+p.y*sin(a),p.y*cos(a)-p.x*sin(a));

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D b;

// Psychedelic julia sets by Kabuto 
// Now properly psychadelic by Psonice
// And now borderline psycho. Psonice

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy * 2. - 2.)*vec2(1.,.5) + vec2(sin(time*.34), cos(time*.55)) * .25;
	float t = sin(time*.3);
	//position = R(position, t*t*.2);
	vec2 src = 1.-abs(fract((vec2(position.x*position.x-position.y*position.y+sin(time*.1)*.25-1.,2.*position.x*position.y+cos(time*.1)*.25)*vec2(.25,.5)+.5)*.5)*2.-1.);
	
	src *= resolution.xy;
	
	vec2 srcf = floor(src);
	vec2 srcn = fract(src);
	
	//srcn *= 0.25;
	vec4 color = vec4(0.0);
	float m = 1.;
	vec2 srcf2 = srcf;
	//for(int i=0; i<4; i++){
		color = (texture2D(b, (srcf+vec2(0,0))/resolution.xy)*(1.-srcn.x)*(1.-srcn.y)
		   + texture2D(b, (srcf+vec2(1,0))/resolution.xy)*srcn.x*(1.-srcn.y)
		   + texture2D(b, (srcf+vec2(0,1))/resolution.xy)*(1.-srcn.x)*srcn.y
		   + texture2D(b, (srcf+vec2(1,1))/resolution.xy)*srcn.x*srcn.y);
		//srcn *= 2.;
		//m *= .5;
	//}
	
	//color *= 400.;
	float l = color.r+color.g+color.b;
	l /= 3.*4.;
	color -= l;
	//color *= color;
	//l = mod((l - .5) * (1.+abs(sin(time*.1))*.1) + .5, 1.);
	l = ((l - .5) * 1.4 + .65);
	//l = mod(l, 3.);
	//l = mod(l, .5);
	color += l;
	color = mix(color, (2.-abs(color - 2.)), 1.-l);
	//color = (color - .5) * 0.9 + .5;
	//color /= 4.;
	
	vec2 p = position*.5;
	float atan = atan(p.y,p.x);
	float dist = length(p);
	
	float dist2 = dist - (cos(atan*9.+time*.7)*.5*cos(time)+cos(atan*15.+time*.2)*.5*sin(time)+1.);
	
	float mask = max(1.-abs(dist2)*(sin(time*.2)*40.+60.),0.);
	
	color = color * (1.-mask) + (cos(time+dist2*vec4(sin(time*.19) * 30. + 192.,sin(time*.17)* 30. + 130.,sin(time*.13)*30. + 100.,0.))*2.0+0.001)*mask;
	
	vec4 bb = texture2D(b, gl_FragCoord.xy);
	
	//color = abs(color.r+color.g+color.b - (bb.r + bb.g+bb.b)) > 2.75 ? mix(bb, color, 0.25) : color;
	
	gl_FragColor = vec4( color );

}