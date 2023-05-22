from pyswip import Prolog 

jazz_engine = Prolog()
jazz_engine.consult("music.pl")



# for note in ['ab1', 'cs1', 'eb1']:
#     other = jazz_engine.query(f"enharmonic({note}, X)")
#     print(f'{note} enharmonic to {other}')
