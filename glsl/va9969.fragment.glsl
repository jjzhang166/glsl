#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// I have no idea what I am doing.
void main( void ) 
{
	//mat2 m = mat2(0.97 * sin(time*0.7),1.3 - sin(time*0.9),1.07,-0.19);
	
	vec2 tex = gl_FragCoord.xy / resolution.xy;
	
	
	
	vec2 p = (( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0);
	vec3 p2 = vec3(p,1.0);
	vec3 c = vec3(p,0.0);

	float t = time + sin(time*1.5) * 0.7;
		mat2 m = mat2(
			cos(t),-sin(t),
			sin(t),cos(t)
			);
	
	for (float i=1.0;i<15.;i++){
		
		p2 *= 1.02;
		p2 += vec3(0.9,0.3,0.05);
		p2.x += atan(sin(i/p2.z));
		p2.xy = m * p2.xy;
		p2.yz = m * p2.yz;
	}
	
	c = p2;
	//c.rg = p2*0.5+vec2(0.5);
	//c.b = 1.0 - (c.r+c.g)*0.5;
	c = mix(c,texture2D(backbuffer,tex).rgb,atan((length(p2.xy-p))*17.7));
	//c = vec3(0.5) + c * 0.5;
	
	c = abs(c);	
	c /= (c + vec3(1.0));
	
	gl_FragColor = vec4(pow(c,vec3(1.0/2.2)),1.0);
	
	/*
	float m;
	i=-(vec2(sin(time*0.5),cos(time*0.5))*0.5+0.5);
	for(int l = 0; l < 17; l++)
		{
		m=atan(dot(atan(p*p)*p,vec2(1,1)));			
		p=abs((p/m)*vec2(1.2,1.3)+i);
		}
	vec3 col=vec3(m*0.5,m*0.125, m );
	gl_FragColor = vec4( (col-normalize(col)*0.85)*2.0, 1.0 );*/
}