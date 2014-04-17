#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 p) {return length(p)-5.;}

float cube(vec3 p, vec3 b, float r) {return length(max(abs(p)-b, 0.0))-r;}

float displacement(vec3 p) {return sin(p.z) * sin(p.y) * 0.3;}


float scene( vec3 p , float ZTime) {float asphere = sphere(p*2.1 + cos(ZTime)); float acube = cube(p, vec3(1.0, 1.0, 1.0),.9 - sin(ZTime)); float both_shapes = min(asphere, acube); float both_shapes_with_displacement = both_shapes + displacement(p*8.0)*0.05; return both_shapes_with_displacement;}

void main( void ) {
	vec2 p = -1.3 + 2.*gl_FragCoord.xy / resolution.xy; p.x *= resolution.x/resolution.y;
	vec3 vuv=vec3(0,1,0); vec3 vrp=vec3(0,1,0); vec3 prp=vec3(sin(time / 4.0)*8.0,cos(time) * 9.0, sin(time) * 7.0);

 
  vec3 vpn=normalize(vrp-prp); vec3 u=normalize(cross(vuv,vpn)); vec3 v=cross(vpn,u); vec3 vcv=(prp+vpn); vec3 scrCoord=vcv+p.x*u+p.y*v; vec3 scp=normalize(scrCoord-prp);

  const vec3 e=vec3(0.1,0,0); const float maxd=94.0; float s=0.1; vec3 c,p1,n;

  float f=0.1; for(int i=0;i<30;i++){f+=s; p1=prp+scp*f; s=scene(p1, time);}
  	
	c=vec3(0.9,0.9,0.9);
    	n=normalize(
      	vec3(s-scene(p1-e.xyy, time),
           s-scene(p1-e.yxy, time),
           s-scene(p1-e.yyx, time)));
    	float b=dot(n,normalize(prp-p1));
    	vec4 tex=vec4((b*c+pow(b,138.0))*(1.0-f*.01),1.0);
	tex += vec4(0.99,0.96,0.9,1.0)/f*1.0;
	
		vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 );
	color *= sin( time / 10.0 ) * 0.3;
	
	gl_FragColor = (f<maxd)?tex:vec4( vec3( color, color * 0.1, 0), 1.0 );


}