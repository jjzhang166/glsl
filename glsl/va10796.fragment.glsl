#ifdef GL_ES																							
precision mediump float;                                                                               
#endif                                                                                                 
                                                                                                       
uniform float time;                                                                                   
                                                                                                        
float calc(float f, vec2 uPos) {             
        float ttime = time * 0.2;
	                                                                            
	uPos.y += sin( ttime + uPos.x * 6.0) * 0.1;                                                             
	uPos.x += sin( ttime + uPos.y * 8.0) + 0.2;                                                             
	float value = sin((uPos.x) * 10.0) + sin(uPos.y * 4.0);                                              
	return 1.0/sqrt(abs(value))/1.0 * pow(f, 2.);                                                      
}                                                                                                      
                                                                                                       
void main( void ) {                                                                                    
	vec2 p = ( gl_FragCoord.xy / 600.0 );		                                                
	p.x = p.x+(4.0/2.0);		                                                
	p.y = p.y+(2.0/2.0);		                                                
	float vertColor = calc(p.y > .5 ? (.5 - (p.y - .5)) * 2. : p.y * 2., p) + 0.12345;                                  
	gl_FragColor = vec4(vertColor, vertColor , vertColor , 1.0)*vec4(0.1,0.2,0.7,1.0)+vec4(0.1,0.1,0.1,1.0);     
} 