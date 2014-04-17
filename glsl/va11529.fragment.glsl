#ifdef GL_ES																							
precision mediump float;                                                                               
#endif                                                                                                 
                                                                                                       
uniform float time;

float calc(float f, vec2 uPos) {             
        float ttime = time * 2.0;
	                                                                            
	uPos.y += sin( ttime + uPos.x * 9.0) * 0.1;                                                             
	uPos.x += sin( ttime + uPos.y * 10.0) + 0.8;                                                             
	float value = sin((uPos.x) * 4.0) + sin(uPos.y * 40.0);                                              
	return 15.0/sqrt(abs(value))/5.0 * pow(f, 2.);                                                      
}                                                                                                      
                                                                                                       
void main( void ) {                                                                                    
	vec2 p = ( gl_FragCoord.xy / 100.0 );		                                                
	p.x = p.x+(4.0/2.0);		                                                
	p.y = p.y+(2.0/2.0);		                                                
	float vertColor = calc(p.y > 0.5 ? (.1 - (p.y - .2)) * .2 : p.y * 2., p) + 0.23456;                                  
	gl_FragColor = vec4(vertColor, vertColor , vertColor , 1.0)*vec4(0.1,0.3,0.5,1.0)+vec4(0.2,0.1,0.2,1.0);     
} 