module Liberic
  module SDK
    module API
      extend FFI::Library
      ffi_lib Liberic.library_path

      def self.attach_eric_function(name, params, return_type, original_name = nil)
        original_name ||= 'Eric' + name.to_s.capitalize.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }
        attach_function(name, original_name, params, return_type)
      end

      # ERICAPI_DECL int STDCALL EricBearbeiteVorgang(
      #     const char* datenpuffer,
      #     const char* datenartVersion,
      #     uint32_t bearbeitungsFlags,
      #     const eric_druck_parameter_t* druckParameter,
      #     const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricTransferHandle* transferHandle,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer,
      #     EricRueckgabepufferHandle serverantwortXmlPuffer);
      attach_eric_function :bearbeite_vorgang, [:string, :string,
          Types::BearbeitungFlag,
          :pointer,
          :pointer,
          :pointer,

          :pointer,
          :pointer], :int

      # ERICAPI_DECL int STDCALL EricChangePassword(const char* psePath, const char* oldPin,
      #     const char* newPin);
      attach_eric_function :change_password, [:string, :string, :string], :int

      # ERICAPI_DECL int STDCALL EricCheckBuFaNummer(const char* steuernummer);
      attach_eric_function :check_bu_fa_nummer, [:string], :int

      # ERICAPI_DECL int STDCALL EricCheckXML(const char* xml, const char* datenartVersion,
      #     EricRueckgabepufferHandle fehlertextPuffer);
      attach_eric_function :check_xml, [:string, :string, :pointer], :int, :EricCheckXML

      # ERICAPI_DECL int STDCALL EricCloseHandleToCertificate(EricZertifikatHandle hToken);
      attach_eric_function :close_handle_to_certificate, [:uint], :int

      # TODO
      # ERICAPI_DECL int STDCALL EricCreateKey(const char* pin, const char* pfad,
      #    const eric_zertifikat_parameter_t* zertifikatInfo);
      attach_eric_function :create_key, [:string, :string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricCreateTH(const char* xml, const char* verfahren,
      #     const char* datenart, const char* vorgang,
      #     const char* testmerker, const char* herstellerId,
      #     const char* datenLieferant, const char* versionClient,
      #     const char* publicKey,
      #     EricRueckgabepufferHandle xmlRueckgabePuffer);
      attach_eric_function :create_th, [:string, :string, :string, :string,
          :string, :string, :string, :string, :string, :pointer], :int, :EricCreateTH

      # ERICAPI_DECL int STDCALL EricDekodiereDaten(
      #     EricZertifikatHandle zertifikatHandle,
      #     const char* pin,
      #     const char* base64Eingabe,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :dekodiere_daten, [:uint, :string, :string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricEinstellungAlleZuruecksetzen(void);
      attach_eric_function :einstellung_alle_zuruecksetzen, [:void], :int

      # ERICAPI_DECL int STDCALL EricEinstellungLesen(const char* name,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :einstellung_lesen, [:string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricEinstellungSetzen(const char* name, const char* wert);
      attach_eric_function :einstellung_setzen, [:string, :string], :int

      # ERICAPI_DECL int STDCALL EricEinstellungZuruecksetzen(const char* name);
      attach_eric_function :einstellung_zuruecksetzen, [:string], :int

      # ERICAPI_DECL int STDCALL EricEntladePlugins();
      attach_eric_function :entlade_plugins, [], :int

      # ERICAPI_DECL int STDCALL EricFormatStNr(const char* eingabeSteuernummer,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :format_st_nr, [:string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricGetAuswahlListen (const char* datenartVersion, const char* feldkennung,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :get_auswahl_listen, [:string, :string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricGetErrormessagesFromXMLAnswer(
      #     const char* xml,
      #     EricRueckgabepufferHandle transferticketPuffer,
      #     EricRueckgabepufferHandle returncodeTHPuffer,
      #     EricRueckgabepufferHandle fehlertextTHPuffer,
      #     EricRueckgabepufferHandle returncodesUndFehlertexteNDHXmlPuffer);
      attach_eric_function :get_errormessages_from_xml_answer, [:string, :pointer, :pointer, :pointer, :pointer], :int, :EricGetErrormessagesFromXMLAnswer

      # ERICAPI_DECL int STDCALL EricGetHandleToCertificate(EricZertifikatHandle* hToken,
      #     uint32_t* iInfoPinSupport,
      #     const char* pathToKeystore);
      attach_eric_function :get_handle_to_certificate, [:pointer, :pointer, :string], :int

      # ERICAPI_DECL int STDCALL EricGetPinStatus(EricZertifikatHandle hToken, uint32_t* pinStatus,
      #     uint32_t keyType);
      attach_eric_function :get_pin_status, [:uint, :pointer, :uint], :int

      # TODO
      # ERICAPI_DECL int STDCALL EricGetPublicKey(const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      # attach_eric_function :get_public_key, [:string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricHoleFehlerText(int fehlerkode,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :hole_fehler_text, [:int, :pointer], :int

      # ERICAPI_DECL int STDCALL EricHoleFinanzaemter(const char* finanzamtLandNummer,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_finanzaemter, [:string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricHoleFinanzamtLandNummern(EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_finanzamt_land_nummern, [:pointer], :int

      # TODO
      # ERICAPI_DECL int STDCALL EricHoleFinanzamtsdaten(const char bufaNr[5],
      #     struct  Finanzamtsdaten *finanzamtsdaten);

      # ERICAPI_DECL int STDCALL EricHoleTestfinanzaemter(EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_testfinanzaemter, [:pointer], :int

      # ERICAPI_DECL int STDCALL EricHoleZertifikatFingerabdruck(
      #     const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricRueckgabepufferHandle fingerabdruckPuffer,
      #     EricRueckgabepufferHandle signaturPuffer);
      attach_eric_function :hole_zertifikat_fingerabdruck, [:pointer, :pointer, :pointer], :int

      # ERICAPI_DECL int STDCALL EricKonvertiereZertifikat(const char* pin, const char* pse);
      attach_eric_function :konvertiere_zertifikat, [:string, :string], :int

      # ERICAPI_DECL int STDCALL EricMakeElsterStnr(const char* steuernrBescheid,
      #     const char landesnr[2+1],
      #     const char bundesfinanzamtsnr[4+1],
      #     EricRueckgabepufferHandle steuernrPuffer);
      # FIXME: non-pointer string
      attach_eric_function :make_elster_stnr, [:string, :string, :string, :pointer], :int

      # ERICAPI_DECL int STDCALL EricPruefeBIC(const char* bic);
      attach_eric_function :pruefe_bic, [:string], :int, :EricPruefeBIC

      # ERICAPI_DECL int STDCALL EricPruefeIBAN(const char* iban);
      attach_eric_function :pruefe_iban, [:string], :int, :EricPruefeIBAN

      # ERICAPI_DECL int STDCALL EricPruefeIdentifikationsMerkmal(const char* steuerId);
      attach_eric_function :pruefe_identifikations_merkmal, [:string], :int

      # ERICAPI_DECL int STDCALL EricPruefeSteuernummer(const char* steuernummer);
      attach_eric_function :pruefe_steuernummer, [:string], :int

      # TODO
      # ERICAPI_DECL int STDCALL EricRegistriereFortschrittCallback(
      #     EricFortschrittCallback funktion,
      #     void* benutzerdaten);

      # TODO
      # ERICAPI_DECL int STDCALL EricRegistriereGlobalenFortschrittCallback(
      #     EricFortschrittCallback funktion,
      #     void* benutzerdaten);

      # typedef void(STDCALL *EricLogCallback)(
      #         const char* kategorie,
      #         eric_log_level_t loglevel,
      #         const char* nachricht,
      #         void* benutzerdaten);
      callback :log_callback, [:string, :int, :string, :pointer], :void

      # ERICAPI_DECL int STDCALL EricRegistriereLogCallback(
      #     EricLogCallback funktion,
      #     uint32_t schreibeEricLogDatei,
      #     void* benutzerdaten);
      attach_eric_function :registriere_log_callback, [:log_callback, :uint, :pointer], :int

      def self.generate_log_callback(&block)
        FFI::Function.new(:void, [:string, :int, :string, :pointer]) do |category, level, message|
          block.call(category, level, message)
        end
      end

      # ERICAPI_DECL EricRueckgabepufferHandle STDCALL EricRueckgabepufferErzeugen();
      attach_eric_function :rueckgabepuffer_erzeugen, [], :pointer

      # ERICAPI_DECL int STDCALL EricRueckgabepufferFreigeben(EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_freigeben, [:pointer], :int

      # ERICAPI_DECL const char* STDCALL EricRueckgabepufferInhalt(EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_inhalt, [:pointer], :string

      # ERICAPI_DECL uint32_t STDCALL EricRueckgabepufferLaenge(EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_laenge, [:pointer], :uint

      # ERICAPI_DECL int STDCALL EricSystemCheck();
      attach_eric_function :system_check, [], :int

      # ERICAPI_DECL int STDCALL EricVersion(EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :version, [:pointer], :int
    end
  end
end
