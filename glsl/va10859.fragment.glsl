#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
 

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy - 0.5;
	vec3 bubbleColor = vec3(0.3,0.,0.);
	vec3 baseColor = vec3(0.7,0.,0.);
	
	float d = 0.0;
	for (int i=0; i<50; i++)
	{
		float speed = sin(0.2+float(i)/5.0)*1.0;
		float fi = float(i);
		vec3 pos = speed*sin(0.2* time*speed*vec3(0.5,0.9,0.75)+fi );

		d += pow(clamp((1.0-abs(distance(vec3(uv.x,uv.y,0.0), pos))),0.0,1.0),25.0);
	}
		
	bubbleColor = mix(bubbleColor, vec3(0.2,0.,0.), clamp(1.-d,0.,1.));
	d = clamp(d,0.0,0.0125)*60.0;	
	
	
	gl_FragColor = vec4(mix(baseColor,bubbleColor,d),1.);
}