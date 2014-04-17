//by @mrdoob, @IndialanJones
//mod ToBSn

//bearing little resemblance to OG. - gtoledo
//2nd version...kinda like some morphing light bulbs-gt
//3rd version...adding some warp. There's a little glitch in the center of the screen in browser, but the shader looks right on desktop-gt
//4th - color.-gt
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
void main( void ) {
		
	
	
	vec2 position = ((-1.+2.*gl_FragCoord.xy / resolution.xy)-(-1.+2.*mouse));
	//shadertoy style deform.-gt
	float a = atan(position.y,position.x);
    	float r = sqrt(dot(position,position));
    	float s = r * (1.0+0.8*cos(time*1.0));

    	float w = .9 + pow(max(1.5-r,0.0),4.0);

   	 w*=0.6+0.4*cos(time+3.0*a);

	position.x =          .02*position.y+.03*cos(-time+a*1.0)/s;
	position.y = .05*time +.02*position.x+.03*sin(-time+a*2.0)/s;
	
	    
	
	float t = 8.;
	//float color = 0.0;
	vec3 color = vec3(sin( position.x * cos( t / 2.0 ) * sin(time*.23)*200. ));//+(time*.05)/50.;// + ( position.y * cos( t / 10.0 ) * sin(time*1.)+4. );
	color.r *= sin( position.y * cos( t / 8.0 ) * 400.0 )+cos(time*2.)-2.;// + cos( position.x * sin( t / 8.0 ) * cos(time*2.)+50. );
	color.g *= cos( position.x * sin( t / 8.0 ) * 400.0 )+sin(time*3.)+1.5;// - sin( position.y * sin( t / 2.0 ) * sin(time));
	color.b -= sin( t / 2.5 );
	color /= 2.3;
	color *=w;
	//float c1 = smoothstep(0.0, color, 5.);
	//float c2 = smoothstep(color, 0.0, 100.);
	//float c3 = c1 + c2;

	gl_FragColor = vec4( vec3(color), 1.0 );

}