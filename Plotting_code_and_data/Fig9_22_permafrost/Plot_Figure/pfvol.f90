PROGRAM pfvol

  IMPLICIT NONE

  INCLUDE "netcdf.inc"

  LOGICAL, PARAMETER :: limit2100 = .TRUE.
  REAL, PARAMETER :: ZeroCelsius = 273.15
  INTEGER, PARAMETER :: nyrref = 20
  INTEGER, PARAMETER :: nyrave = 2
  INTEGER, PARAMETER :: mpy = 12
  REAL, PARAMETER :: dtbin = .2
  REAL, PARAMETER :: tbinmin = -3.
  REAL, PARAMETER :: tbinmax = 15.
  REAL, DIMENSION(:,:), ALLOCATABLE :: areacella, sftgif, sftlf, zbound, pft
  LOGICAL, DIMENSION(:,:), ALLOCATABLE :: masque
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: tas
  REAL, DIMENSION(:,:,:,:), ALLOCATABLE :: tsl
  REAL, DIMENSION(:), ALLOCATABLE :: x, y, z, time, GMAT, dGMAT, dGMAT20yr, &
                                     zext, dz, pfv
  REAL :: aireterre, tf1cib, dt, GMATref
  REAL :: spval
  REAL, PARAMETER :: spvaldef = -1.e20
  INTEGER :: ia, natts
  INTEGER :: iret, fid, vid, tvidh, it, iz, mave, izref
  INTEGER :: ic, icmod, itr, ix, iy
  INTEGER, DIMENSION(4) :: start, count
  CHARACTER(LEN=80) :: executable, model, scenario, depthstr, vn, &
                       xname, yname, tname, zname, zboundname, attname,pathout
  CHARACTER(LEN=200):: fname
  INTEGER, DIMENSION(4) :: dimids
  REAL :: depth
  INTEGER :: nx,ny,nz,nt,ntr
  LOGICAL :: gif100, fois100
  INTEGER :: fidh, fidf, nth, ntf, vidh, vidf
  INTEGER :: tdimid, tvarid, gmatvarid, gmat20yrvarid, pfvarid
  INTEGER :: nbin, ibin, npf, binin
  REAL, ALLOCATABLE, DIMENSION(:) :: tbin, pfbin, tbinm, tbinp
  INTEGER, ALLOCATABLE, DIMENSION(:) :: npfbin
  INTEGER :: bindimid, binvarid, pfbinvarid

  !
  !
  !

  spval = spvaldef

  mave = nyrave*mpy

  CALL get_command_argument(0, executable)
  CALL get_command_argument(1, model)
  CALL get_command_argument(2, scenario)
  CALL get_command_argument(3, depthstr)

  IF ( LEN_TRIM(model) .EQ. 0 .OR. &
       LEN_TRIM(scenario) .EQ. 0 .OR. &
       LEN_TRIM(depthstr) .EQ. 0 ) THEN
    WRITE(*,*) 'Usage : '//TRIM(executable)//' model scenario profondeur'
    STOP
  ENDIF

  READ(depthstr,*) depth
  IF ( depth .LE. 0. ) THEN
    STOP 'Profondeur > 0 requise.'
  ENDIF

  WRITE(*,*) TRIM(model), ' ',TRIM(scenario),' ',depth

  gif100 = .FALSE.; IF ( model .EQ. 'IPSL-CM6A-LR' ) gif100 = .TRUE.
  fois100 = .FALSE.; IF ( model .EQ. 'BCC-CSM2-MR' ) fois100 = .TRUE.

  ! areacella

  vn = "areacella"
  iret = NF_OPEN('/home/gkrinner/CMIP6/masques/'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  IF ( iret .NE. 0 ) &
    iret = NF_OPEN('/home/gkrinner/CMIP6/masques/pseudo_'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  CALL erreur(iret,.TRUE.,"open "//TRIM(vn))

  CALL erreur(NF_INQ_VARID(fid,TRIM(vn),vid),.TRUE.,"inq varid 1 "//TRIM(vn))
  CALL erreur(NF_INQ_VARDIMID(fid,vid,dimids),.TRUE.,"inq dimids")
  CALL erreur(NF_INQ_DIMLEN(fid,dimids(1),nx),.TRUE.,"inq dimlen")
  CALL erreur(NF_INQ_DIMNAME(fid,dimids(1),xname),.TRUE.,"inq dimname")
  CALL erreur(NF_INQ_DIMLEN(fid,dimids(2),ny),.TRUE.,"inq dimlen")
  CALL erreur(NF_INQ_DIMNAME(fid,dimids(2),yname),.TRUE.,"inq dimname")

  ALLOCATE(x(nx),y(ny),areacella(nx,ny))
  CALL erreur(NF_GET_VAR_REAL(fid,vid,areacella),.TRUE.,"get var real")
  aireterre = SUM(areacella(:,:))

  CALL erreur(NF_INQ_VARID(fid,xname,vid),.TRUE.,"inq varid 2 "//TRIM(xname))
  CALL erreur(NF_GET_VAR_REAL(fid,vid,x),.TRUE.,"get var real")
  CALL erreur(NF_INQ_VARID(fid,yname,vid),.TRUE.,"inq varid 3 "//TRIM(yname))
  CALL erreur(NF_GET_VAR_REAL(fid,vid,y),.TRUE.,"get var real")

  CALL erreur(NF_CLOSE(fid),.TRUE.,"close "//TRIM(vn))

  ! sftgif

  vn = "sftgif"
  iret = NF_OPEN('/home/gkrinner/CMIP6/masques/'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  IF ( iret .NE. 0 ) &
    iret = NF_OPEN('/home/gkrinner/CMIP6/masques/pseudo_'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  CALL erreur(iret,.TRUE.,"open "//TRIM(vn))

  CALL erreur(NF_INQ_VARID(fid,TRIM(vn),vid),.TRUE.,"inq varid 4"//TRIM(vn))
  ALLOCATE(sftgif(nx,ny))
  CALL erreur(NF_GET_VAR_REAL(fid,vid,sftgif),.TRUE.,"get var real")

  ! spval
  iret = NF_GET_ATT_REAL(fid,vid,"missing_value",spval)

  CALL erreur(NF_CLOSE(fid),.TRUE.,"close "//TRIM(vn))

  IF ( gif100 ) WHERE ( sftgif(:,:) .GT. 0. ) sftgif(:,:) = 100.

  ! sftlf

  vn = "sftlf"
  iret = NF_OPEN('/home/gkrinner/CMIP6/masques/'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  IF ( iret .NE. 0 ) &
    iret = NF_OPEN('/home/gkrinner/CMIP6/masques/pseudo_'//TRIM(vn)//'/'//TRIM(vn)//'_'//TRIM(model)//'.nc',NF_NOWRITE,fid)
  CALL erreur(iret,.TRUE.,"open "//TRIM(vn))

  CALL erreur(NF_INQ_VARID(fid,TRIM(vn),vid),.TRUE.,"inq varid 5"//TRIM(vn))
  ALLOCATE(sftlf(nx,ny))
  CALL erreur(NF_GET_VAR_REAL(fid,vid,sftlf),.TRUE.,"get var real")

  ! spval
  iret = NF_GET_ATT_REAL(fid,vid,"missing_value",spval)

  CALL erreur(NF_CLOSE(fid),.TRUE.,"close "//TRIM(vn))

  ! tas 
  vn = "tas"
  CALL get_1filename('/data/gkrinner/CMIP6/CMIP/historical/Amon/'//TRIM(vn)//'/',TRIM(model),fname)
  CALL erreur(NF_OPEN(TRIM(fname),NF_NOWRITE,fidh),.TRUE.,"open tas historical")
  CALL get_1filename('/data/gkrinner/CMIP6/ScenarioMIP/'//TRIM(scenario)//'/Amon/'//TRIM(vn)//'/',TRIM(model),fname)
  CALL erreur(NF_OPEN(TRIM(fname),NF_NOWRITE,fidf),.TRUE.,"open tas scenario")

  CALL erreur(NF_INQ_VARID(fidh,TRIM(vn),vidh),.TRUE.,"inq varid 6"//TRIM(vn))
  CALL erreur(NF_INQ_VARDIMID(fidh,vidh,dimids),.TRUE.,"inq dimids")
  CALL erreur(NF_INQ_DIMLEN(fidh,dimids(3),nth),.TRUE.,"inq dimlen")
  CALL erreur(NF_INQ_DIMNAME(fidh,dimids(3),tname),.TRUE.,"inq dimname")

  CALL erreur(NF_INQ_VARID(fidf,TRIM(vn),vidf),.TRUE.,"inq varid 7"//TRIM(vn))
  CALL erreur(NF_INQ_VARDIMID(fidf,vidf,dimids),.TRUE.,"inq dimids")
  CALL erreur(NF_INQ_DIMLEN(fidf,dimids(3),ntf),.TRUE.,"inq dimlen")
  IF ( TRIM(model) .EQ. "NorESM2-LM" .OR. TRIM(model) .EQ. "NorESM2-MM" ) THEN
    ntf = ntf-1
  ENDIF

  nt = nth + ntf
  ALLOCATE(tas(nx,ny,nt),time(nt))

  CALL erreur(NF_INQ_VARID(fidh,tname,tvidh),.TRUE.,"inq varid 8"//TRIM(tname))
  CALL erreur(NF_GET_VAR_REAL(fidh,tvidh,time(1:nth)),.TRUE.,"get var real")
  CALL erreur(NF_INQ_VARID(fidf,tname,vid),.TRUE.,"inq varid 9"//TRIM(tname))
  IF ( TRIM(model) .EQ. "NorESM2-LM" .OR. TRIM(model) .EQ. "NorESM2-MM" ) THEN
    start(1) = 2; count(1) = ntf
  ELSE
    start(1) = 1; count(1) = ntf
  ENDIF
  CALL erreur(NF_GET_VARA_REAL(fidf,vid,start,count,time(nth+1:nt)),.TRUE.,"get vara real")
  ! corriger time s il faut
  tf1cib = time(nth) + (time(nth-11)-time(nth-12))
  dt = tf1cib - time(nth+1)
  time(nth+1:nt) = time(nth+1:nt) + dt

  CALL erreur(NF_GET_VAR_REAL(fidh,vidh,tas(:,:,1:nth)),.TRUE.,"get var real")
  start(1) = 1; count(1) = nx
  start(2) = 1; count(2) = ny
  IF ( TRIM(model) .EQ. "NorESM2-LM" .OR. TRIM(model) .EQ. "NorESM2-MM" ) THEN
    start(3) = 2; count(3) = ntf
  ELSE
    start(3) = 1; count(3) = ntf
  ENDIF
  CALL erreur(NF_GET_VARA_REAL(fidf,vidf,start,count,tas(:,:,nth+1:nt)),.TRUE.,"get var real")

  ! spval
  iret = NF_GET_ATT_REAL(fidh,vidh,"missing_value",spval)
  iret = NF_GET_ATT_REAL(fidf,vidf,"missing_value",spval)

  CALL erreur(NF_CLOSE(fidh),.TRUE.,"close hist "//TRIM(vn))
  CALL erreur(NF_CLOSE(fidf),.TRUE.,"close scen "//TRIM(vn))

  ALLOCATE( GMAT(nt), dGMAT(nt), dGMAT20yr(nt) )
  DO it = 1, nt
    GMAT(it) = SUM(tas(:,:,it)*areacella(:,:))/aireterre
  ENDDO

  GMATref = SUM(GMAT(nth-nyrref*mpy+1:nth))/FLOAT(nyrref*mpy)
  WRITE(*,*) 'GMAT 1995-2014 : ', GMATref-ZeroCelsius
  dGMAT(:) = GMAT(:) - GMATref

  DO it = nyrref*mpy/2,nt-nyrref*mpy/2
    dGMAT20yr(it) = SUM(dGMAT(it-nyrref*mpy/2+1:it+nyrref*mpy/2))/FLOAT(nyrref*mpy)
  ENDDO
  dGMAT20yr(1:nyrref*mpy/2-1) = dGMAT20yr(nyrref*mpy/2)
  dGMAT20yr(nt-nyrref*mpy/2+1:nt) = dGMAT20yr(nt-nyrref*mpy/2)

  DEALLOCATE(tas)

  ! tsl
  vn = "tsl"
  CALL get_1filename('/data/gkrinner/CMIP6/CMIP/historical/Lmon/'//TRIM(vn)//'/',TRIM(model),fname)
  CALL erreur(NF_OPEN(TRIM(fname),NF_NOWRITE,fidh),.TRUE.,"open tas historical")
  CALL get_1filename('/data/gkrinner/CMIP6/ScenarioMIP/'//TRIM(scenario)//'/Lmon/'//TRIM(vn)//'/',TRIM(model),fname)
  CALL erreur(NF_OPEN(TRIM(fname),NF_NOWRITE,fidf),.TRUE.,"open tas scenario")

  CALL erreur(NF_INQ_VARID(fidh,TRIM(vn),vidh),.TRUE.,"inq varid 10"//TRIM(vn))
  CALL erreur(NF_INQ_VARID(fidf,TRIM(vn),vidf),.TRUE.,"inq varid 11"//TRIM(vn))

  CALL erreur(NF_INQ_VARDIMID(fidh,vidh,dimids),.TRUE.,"inq dimids")
  CALL erreur(NF_INQ_DIMLEN(fidh,dimids(3),nz),.TRUE.,"inq dimlen")
 
  ! z
  CALL erreur(NF_INQ_DIMNAME(fidh,dimids(3),zname),.TRUE.,"inq dimname")
  CALL erreur(NF_INQ_VARID(fidh,zname,vid),.TRUE.,"inq varid 12"//TRIM(zname))

  ALLOCATE(z(nz), zbound(2,nz))
  CALL erreur(NF_GET_VAR_REAL(fidh,vid,z),.TRUE.,"get var real")

  ! bounds z
  iret = NF_GET_ATT_TEXT(fidh,vid,"bounds",zboundname)
  IF ( iret .EQ. 0 ) iret = NF_INQ_VARID(fidh,zboundname,vid)
  IF ( iret .EQ. 0 ) THEN
    CALL erreur(NF_GET_VAR_REAL(fidh,vid,zbound),.TRUE.,"get var real")
  ELSE
    ! on se bricole un truc
    ALLOCATE(zext(0:nz+1))
    zext(0) = 0.
    zext(1:nz) = z(1:nz) 
    zext(nz+1) = z(nz) + (z(nz)-z(nz-1))
    zbound(1,1) = 0.
    zbound(2,1) = (zext(2)+zext(1))/2.
    DO iz = 2, nz 
      zbound(1,iz) = zbound(2,iz-1) 
      zbound(2,iz) = (zext(iz+1)+zext(iz))/2.
    ENDDO
    DEALLOCATE(zext)
  ENDIF

  ! determiner jusqu ou il faut aller en z
  DO iz = 1, nz
    IF ( zbound(1,iz) .LT. depth ) izref = iz
  ENDDO
  WRITE(*,*) 'Niveau z selectionne : ', izref, ' / ', nz, ', milieu a ', z(izref),' m'
  ALLOCATE(dz(izref))
  dz(1:izref-1) = zbound(2,1:izref-1)-zbound(1,1:izref-1)
  dz(izref) = depth-zbound(1,izref)

  ALLOCATE( tsl(nx,ny,izref,mave) )
  ALLOCATE( pft(nx,ny), masque(nx,ny) )
  ALLOCATE( pfv(nt) )
  pfv(:) = spval

  WHERE ( sftlf(:,:) .GT. 0. .AND. sftgif(:,:) .NE. 100. )
    masque(:,:) = .TRUE.
  ELSEWHERE
    masque(:,:) = .FALSE.
  ENDWHERE
  WHERE ( ABS(sftgif(:,:)-spval) .LT. EPSILON(spval) ) masque(:,:) = .FALSE.
  WHERE ( ABS(sftlf(:,:)-spval) .LT. EPSILON(spval) ) masque(:,:) = .FALSE.

  DO it = mave/2, nt-mave/2

    ic = it+mave/2

    icmod = MOD( ic-1, mave ) + 1

    IF ( ic .EQ. mave ) THEN
      ! lire  
      start(1) = 1; count(1) = nx
      start(2) = 1; count(2) = ny
      start(3) = 1; count(3) = izref
      start(4) = 1; count(4) = mave
      CALL erreur(NF_GET_VARA_REAL(fidh,vidh,start,count,tsl),.TRUE.,"get var real")
      DO iz = 1, izref
        DO ix = 1, nx
        DO iy = 1, ny
          IF ( masque(ix,iy) ) THEN
            IF ( ANY(ABS(tsl(ix,iy,iz,:)-spval) .LT. EPSILON(spval)) ) THEN
              masque(ix,iy) = .FALSE.
            ENDIF
          ENDIF
        ENDDO
        ENDDO
      ENDDO
    ELSE
      itr = it + mave/2
      IF ( itr .LE. nth ) THEN
        fid = fidh; vid = vidh
      ELSE
        itr = itr - nth
        fid = fidf; vid = vidf
      ENDIF
      start(4) = itr; count(4) = 1
      CALL erreur(NF_GET_VARA_REAL(fid,vid,start,count,tsl(:,:,:,icmod)),.TRUE.,"get var real")
      DO ix = 1, nx
      DO iy = 1, ny
        DO iz = 1, izref
          IF ( masque(ix,iy) ) THEN
            IF ( ABS(tsl(ix,iy,iz,icmod)-spval) .LT. EPSILON(spval) ) THEN
              masque(ix,iy) = .FALSE.
            ENDIF
          ENDIF
        ENDDO
      ENDDO
      ENDDO
    ENDIF

    pft(:,:) = 0.
    DO iz = 1, izref
      DO ix = 1, nx
      DO iy = 1, ny
        IF ( masque(ix,iy) ) THEN
          IF ( ALL(tsl(ix,iy,iz,:) .LT. ZeroCelsius) ) THEN
            pft(ix,iy) = pft(ix,iy) + areacella(ix,iy) * sftlf(ix,iy)/100. * ( 1.-sftgif(ix,iy)/100. ) * dz(iz)
          ENDIF
        ENDIF
        IF ( pft(ix,iy) .LT. 0. ) THEN
          WRITE(*,*) pft(ix,iy),areacella(ix,iy),sftlf(ix,iy),sftgif(ix,iy),dz(iz)
          WRITE(*,*) spval
          STOP
        ENDIF
      ENDDO
      ENDDO
    ENDDO
    pfv(it) = SUM(pft(:,:),mask=masque(:,:))/1.e9

  ENDDO

  IF ( limit2100 ) THEN
    ntr = nth + MIN((2100-2014)*12,ntf)
  ELSE
    ntr = nt
  ENDIF

  nbin = (tbinmax-tbinmin)/dtbin
  ALLOCATE(tbin(nbin),tbinm(nbin),tbinp(nbin),pfbin(nbin),npfbin(nbin))
  tbinm(1) = tbinmin
  tbin(1) = tbinmin + dtbin/2.
  tbinp(1) = tbinmin + dtbin
  DO ibin = 2, nbin
    tbinm(ibin) = tbinm(ibin-1) + dtbin
    tbin(ibin) = tbin(ibin-1) + dtbin
    tbinp(ibin) = tbinp(ibin-1) + dtbin
  ENDDO
  npfbin(:) = 0 
  pfbin(:) = 0.
  DO it = 1, ntr
    IF ( ABS(pfv(it)-spval) .GT. EPSILON(spval) ) THEN
      DO ibin = 1, nbin
        IF ( dGMAT20yr(it) .GE. tbinm(ibin) .AND. &
             dGMAT20yr(it) .LT. tbinp(ibin) ) THEN
          binin = ibin
        ENDIF
      ENDDO
      pfbin(binin) = pfbin(binin) + pfv(it)
      npfbin(binin) = npfbin(binin) + 1    
    ENDIF
  ENDDO
  DO ibin = 1, nbin
    IF ( npfbin(ibin) .GT. 0 ) THEN
      pfbin(ibin) = pfbin(ibin)/FLOAT(npfbin(ibin))
    ELSE
      pfbin(ibin) = spval
    ENDIF
  ENDDO  

  pathout = 'pfvolbin-'//TRIM(depthstr)//'m'
  CALL SYSTEM('mkdir '//TRIM(pathout)//' >/dev/null 2>&1')
  CALL erreur(NF_CREATE(TRIM(pathout)//'/pfv_'//TRIM(model)//'_historical+'//TRIM(scenario)//'.nc',NF_CLOBBER,fid),.TRUE.,"create")
  CALL erreur(NF_DEF_DIM(fid,"bin",nbin,bindimid),.TRUE.,"def dim") 
  CALL erreur(NF_DEF_VAR(fid,"bin",NF_FLOAT,1,bindimid,binvarid),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,binvarid,"units",1,"K"),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,binvarid,"long_name",11,"GMAT change"),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,binvarid,"standard_name",5,"dGMAT"),.TRUE.,"def var")
  CALL erreur(NF_DEF_DIM(fid,tname,ntr,tdimid),.TRUE.,"def dim") 
  CALL erreur(NF_DEF_VAR(fid,tname,NF_FLOAT,1,tdimid,tvarid),.TRUE.,"def var")
  CALL erreur(NF_INQ_VARID(fidh,tname,tvidh),.TRUE.,"inq varid 14"//TRIM(tname))
  CALL erreur(NF_INQ_VARNATTS(fidh, tvidh, natts),.TRUE.,"inq varnatts")
  DO ia = 1, natts
    CALL erreur(NF_INQ_ATTNAME(fidh,tvidh,ia,attname),.TRUE.,"inq attname")
    IF ( attname(LEN_TRIM(attname)-5:LEN_TRIM(attname)) .NE. "bounds" ) &
      CALL erreur(NF_COPY_ATT(fidh,tvidh,attname,fid,tvarid),.TRUE.,"copy att")
  ENDDO
  !
  CALL erreur(NF_DEF_VAR(fid,"pfbin",NF_FLOAT,1,bindimid,pfbinvarid),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_REAL(fid,pfbinvarid,"missing_value",NF_FLOAT,1,spval),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,pfbinvarid,"units",4,"km^3"),.TRUE.,"def var")
  CALL erreur(NF_DEF_VAR(fid,"dGMAT",NF_FLOAT,1,tdimid,gmatvarid),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_REAL(fid,gmatvarid,"missing_value",NF_FLOAT,1,spval),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,gmatvarid,"units",1,"K"),.TRUE.,"def var")
  CALL erreur(NF_DEF_VAR(fid,"dGMAT20yr",NF_FLOAT,1,tdimid,gmat20yrvarid),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_REAL(fid,gmat20yrvarid,"missing_value",NF_FLOAT,1,spval),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,gmat20yrvarid,"units",1,"K"),.TRUE.,"def var")
  CALL erreur(NF_DEF_VAR(fid,"pfv",NF_FLOAT,1,tdimid,pfvarid),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_REAL(fid,pfvarid,"missing_value",NF_FLOAT,1,spval),.TRUE.,"def var")
  CALL erreur(NF_PUT_ATT_TEXT(fid,pfvarid,"units",4,"km^3"),.TRUE.,"def var")
  CALL erreur(NF_ENDDEF(fid),.TRUE.,"enddef")
  CALL erreur(NF_PUT_VAR_REAL(fid,binvarid,tbin),.TRUE.,"put var real")
  CALL erreur(NF_PUT_VAR_REAL(fid,tvarid,time),.TRUE.,"put var real")
  CALL erreur(NF_PUT_VAR_REAL(fid,pfbinvarid,pfbin),.TRUE.,"put var real")
  CALL erreur(NF_PUT_VAR_REAL(fid,gmatvarid,dGMAT),.TRUE.,"put var real")
  CALL erreur(NF_PUT_VAR_REAL(fid,gmat20yrvarid,dGMAT20yr),.TRUE.,"put var real")
  CALL erreur(NF_PUT_VAR_REAL(fid,pfvarid,pfv),.TRUE.,"put var real")
  
  CALL erreur(NF_CLOSE(fidh),.TRUE.,"close hist "//TRIM(vn))
  CALL erreur(NF_CLOSE(fidf),.TRUE.,"close scen "//TRIM(vn))
  CALL erreur(NF_CLOSE(fid),.TRUE.,"close output ")

END PROGRAM pfvol

SUBROUTINE get_1filename(path,model,fname)

  IMPLICIT NONE

  CHARACTER(LEN=*), INTENT(in) :: path, model
  CHARACTER(LEN=*), INTENT(out) :: fname

  CALL SYSTEM('ls -1 '//TRIM(path)//'/*_'//TRIM(model)//'_*.nc | head -n 1 > tmp.txt')
  OPEN(10,FILE='tmp.txt',STATUS='old')
  READ(10,'(a)') fname
  CLOSE(10)
  CALL SYSTEM('rm -f tmp.txt')

END SUBROUTINE get_1filename

SUBROUTINE erreur(iret, lstop, chaine)
  ! pour les messages d'erreur
  INTEGER, INTENT(in)                     :: iret
  LOGICAL, INTENT(in)                     :: lstop
  CHARACTER(LEN=*), INTENT(in)            :: chaine
  !
  CHARACTER(LEN=256)                      :: message
  !
  INCLUDE "netcdf.inc"
  !
  IF ( iret .NE. 0 ) THEN
    WRITE(*,*) 'ROUTINE: ', TRIM(chaine)
    WRITE(*,*) 'ERREUR: ', iret
    message=NF_STRERROR(iret)
    WRITE(*,*) 'CA VEUT DIRE:',TRIM(message)
    IF ( lstop ) STOP
  ENDIF
  !
END SUBROUTINE erreur
