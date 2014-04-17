#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float segmentShape(vec2 p, vec2 s0, vec2 s1, float radius)
{
	vec2 d = normalize(s1 - s0);
	float slen = distance(s0, s1);

	float 	d0 = max(abs(dot(p - s0, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(p - s0, d) - slen * 0.5) - slen * 0.5, 0.0);

		
	return step(length(vec2(d0, d1)), radius*30.0)*0.008/(length(vec2(d0, d1)));
		
}
void main( void ) 
{
         float zoom = 1.0;
         float scale = 64.0;

	// vec2 position = ( gl_FragCoord.xy / resolution.xy );
        vec2 position = vec2((gl_FragCoord.x / resolution.y )*2.0 - resolution.x/resolution.y - 0.7,gl_FragCoord.y / resolution.y*2.0 - 0.5);
        position *= zoom;


     	//параметры фрактала
        float seed = 0.13478;
        float angle = 1.0;//30 градусов
        float step = 0.2;

        
        // дан отрезок
        // начало в (0.0,0.0) конец в (1.0,1.0)

       vec2 p0 = vec2(0.0,0.0);
       vec2 p1 = vec2(1.0,1.0);
   //	vec2 p1 = vec2((mouse.x - 0.5)*4.0,(mouse.y - 0.5)*2.0);
 
	float color = segmentShape(position,p0,p1,scale);

	gl_FragColor = vec4( vec3(0.1*color,color,0.0*color), 1.0 ) + vec4(position.x < 1.0 && position.x  > 0.0 && position.y < 1.0 && position.y  > 0.0,0.0,0.0,0.0);

}