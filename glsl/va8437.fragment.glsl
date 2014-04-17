#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy-0.5)  ;
	
	vec3 color =vec3(1.0+p.y*1.2,0.8+p.y*9.,2.8+p.y*8.);
	vec3 a ;
	float Mx = 22.;
	for ( float i	=21. ; i > 8.0; i-- ){
		color	*=	0.8;
//		color	=	pow(color,1.1);
		
		vec2 nNoise = vec2(time*(0.5+i*0.1),p.x*(sin(-p.x*20.-time*5.)*2.+0.5+i*0.3));
		const vec2 d = vec2(0.0, 1.0);
		vec2 b = floor(nNoise), f = smoothstep(vec2(0.0), vec2(1.0), fract(nNoise));
		
		float rand1 = fract(sin(dot(b, vec2(12.9898, 4.1414))) * 43758.5453);
		float rand2 = fract(sin(dot((b + d.yx), vec2(12.9898, 4.1414))) * 43758.5453);
		float rand3 = fract(sin(dot((b + d.xy), vec2(12.9898, 4.1414))) * 43758.5453);
		float rand4 = fract(sin(dot((b + d.yy), vec2(12.9898, 4.1414))) * 43758.5453);
		
		float noise = mix(mix(rand1, rand2, f.x), mix(rand3, rand4, f.x), f.y);
		p.xy	=p *(1.0+sin(p.yx*20.-noise*5.)*0.02);
		vec3 Br = vec3(1.0+cos(p.x+time*0.5)*0.1,1.0-sin(p.x+time)*0.1,1.0+cos(p.x-time)*0.1)*(1.0+sin(time*0.1)*0.8);
		a = vec3(p.y) + sin(p.x*(i*0.5)+time*2.+sin(time*(0.001*Br + i*0.0001))*5.0+noise)*0.005*i-0.05*sin(time+i*0.2);
		
		color += sin(max(vec3(0.0),pow(1.0-abs(a),vec3(1000.)*Br/(i*0.3))*0.2+pow(1.0-abs(a),vec3(30.)/Br)*0.25));
		
		
		if(a.x < 0.0){
			color += vec3(0.6-i*0.1,-1.5+i*0.2,0.5+i*0.05)*(0.4-pow(a.x,5.)*5.)*0.13*Br;
		
		}
	}

	gl_FragColor = vec4( color, 1.0 );
}